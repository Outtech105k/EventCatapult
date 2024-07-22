part of 'database.dart';

@DataClassName('Place')
class Places extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get description => text().withLength(min: 0, max: 1000)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
}
