/*
 * Main
 * アプリの基本情報設定
 */

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gps_reminder/config.dart';
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
        title: AppConfig.appName,
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
          title: AppConfig.appName,
          database: database,
        ),

        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("en",""),
          Locale("ja",""),
        ]
    );
  }
}
