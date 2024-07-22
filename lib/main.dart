import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/reminders.dart';
import 'pages/locations.dart';
import 'services/location.dart';
import 'database/reminds.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
    required this.database
  });

  final String title;
  final AppDatabase database;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // 描画完了後、権限の許可を求める
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(!await checkLocationPermissions()){
        SystemNavigator.pop();
      }
    });

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            bottom: const TabBar(
              tabs: <Widget> [
                Tab(icon: Icon(Icons.notifications)),
                Tab(icon: Icon(Icons.location_pin)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              RemindersPage(database: widget.database),
              const LocationsPage(),
            ],
          ),
        )
    );
  }
}
