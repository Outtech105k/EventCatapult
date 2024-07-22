import 'package:flutter/material.dart';
import 'database/reminds.dart';
import 'pages/home.dart';

void main() {
  final database = AppDatabase();
  runApp(ReminderApp(database: database));
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({
    super.key,
    required this.database,
  });

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS Reminder',
      theme: ThemeData(
        colorSchemeSeed: Colors.blueAccent,
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'NotoSansJP',
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blueAccent,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: HomePage(
        title: 'GPS Reminder',
        database: database,
      ),
    );
  }
}
