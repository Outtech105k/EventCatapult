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
  TextColumn get title => text().withLength(min: 1, max: 50)();
  TextColumn get content => text().withLength(min: 0, max: 1000)();
}

/* ---------- CRUD ---------- */
Stream<List<Remind>> watchAllReminds(AppDatabase db){
  return db.select(db.reminds).watch();
}

Future insertRemind(AppDatabase db, Remind remind) {
  return db.into(db.reminds).insert(remind);
}

Future deleteRemind(AppDatabase db, Remind remind) {
  return db.delete(db.reminds).delete(remind);
}

/* ---------- DB CREATION ---------- */
@DriftDatabase(tables: [Reminds, Places])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
