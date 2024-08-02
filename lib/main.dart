/*
 * Main
 * アプリの基本情報設定
 */

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'database/database.dart';
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
        debugShowCheckedModeBanner: false,
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
            fontFamily: 'NotoSansJP'
        ),
        home: HomePage(
          title: 'Event Catapult',
          database: database,
        ),

        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("en"),
          Locale("ja"),
        ]
    );
  }
}
