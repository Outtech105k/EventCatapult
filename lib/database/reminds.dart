part of 'database.dart';

@DataClassName('Remind')
class Reminds extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 50)();
  TextColumn get content => text().withLength(min: 0, max: 1000)();
}

Stream<List<Remind>> watchAllReminds(AppDatabase db){
  return db.select(db.reminds).watch();
}

Future insertRemind(AppDatabase db, Remind remind) {
  return db.into(db.reminds).insert(remind);
}
