import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'reminds.g.dart';

@DataClassName('Remind')
class Reminds extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 50)();
  TextColumn get content => text().withLength(min: 0, max: 1000)();
}

@DriftDatabase(tables: [Reminds])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

// ---------- CRUD ----------
// select
Stream<List<Remind>> watchAllReminds(AppDatabase db){
  return db.select(db.reminds).watch();
}

// insert
Future insertRemind(AppDatabase db, Remind remind) {
  return db.into(db.reminds).insert(remind);
}

// update
Future updateRemind(AppDatabase db, Remind remind) {
  return db.update(db.reminds).replace(remind);
}

Future deleteRemind(AppDatabase db, Remind remind) {
  return db.delete(db.reminds).delete(remind);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'reminds.sqlite'));
    return NativeDatabase(file);
  });
}
