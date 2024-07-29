/*
 * Database
 * ローカルデータベース(Drift)
 * TODO: スキーマ変更時にコマンド実行: `dart run build_runner build`
 */

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../config.dart';

part 'database.g.dart';

/* ---------- SCHEMAS ---------- */
// 登録地点の保存テーブル
@DataClassName('Place')
class Places extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: PlacesConfig.nameMaxLength)();
  TextColumn get description => text().withLength(min: 0, max: PlacesConfig.descriptionMaxLength)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
}

// リマインドの保存テーブル
@DataClassName('Remind')
class Reminds extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: RemindsConfig.nameMaxLength)();
  TextColumn get detail => text().withLength(min: 0, max: RemindsConfig.detailMaxLength)();
  IntColumn get placeId => integer().references(Places, #id)();
  DateTimeColumn get deadline => dateTime()();
}

/* ---------- CRUD ---------- */
Future upsertPlace(AppDatabase db, PlacesCompanion place) {
  return db.into(db.places).insertOnConflictUpdate(place);
}

Future deletePlace(AppDatabase db, Place place) {
  return db.delete(db.places).delete(place);
}

Future<Place?> selectPlaceById(AppDatabase db, int id){
  return (db.select(db.places)..where((u) => u.id.equals(id))).getSingleOrNull();
}

Stream<List<Place>> watchAllPlaces(AppDatabase db){
  return db.select(db.places).watch();
}

Future upsertRemind(AppDatabase db, RemindsCompanion remind) {
  return db.into(db.reminds).insertOnConflictUpdate(remind);
}

Future deleteRemind(AppDatabase db, Remind remind) {
  return db.delete(db.reminds).delete(remind);
}

Stream<List<Remind>> watchAllReminds(AppDatabase db){
  return db.select(db.reminds).watch();
}

/* ---------- JOINyy SCHEMAS ---------- */

// リマインドと地点の結合結果を保持するクラス
class RemindWithPlace {
  final Remind remind;
  final Place place;

  RemindWithPlace({
    required this.remind,
    required this.place,
  });
}

/* ---------- DB CREATION ---------- */

@DriftDatabase(tables: [Reminds, Places])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // 連結クエリ
  Stream<List<RemindWithPlace>> watchAllRemindsWithPlaces() {
    final query = (select(reminds)..orderBy([(t) => OrderingTerm(expression: t.deadline)]))
        .join([
      innerJoin(places, places.id.equalsExp(reminds.placeId)),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return RemindWithPlace(
          remind: row.readTable(reminds),
          place: row.readTable(places),
        );
      }).toList();
    });
  }

  // 現在時刻から次に迎えるRemindを取得
  Stream<RemindWithPlace?> watchNextUpcomingRemind() {
    final now = DateTime.now();

    final query = (select(reminds)..where((r) => r.deadline.isBiggerThanValue(now)))
      ..orderBy([(r) => OrderingTerm(expression: r.deadline, mode: OrderingMode.asc)])
      ..limit(1);

    return query.join(
      [
        innerJoin(places, places.id.equalsExp(reminds.placeId)),
      ],
    ).watchSingleOrNull().map((row) {
      if (row != null) {
        return RemindWithPlace(
          remind: row.readTable(reminds),
          place: row.readTable(places),
        );
      } else {
        return null;
      }
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
