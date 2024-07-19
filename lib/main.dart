import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/reminders.dart';
import 'pages/locations.dart';
import 'pages/settings.dart';
import 'gps/location.dart';

void main() {
  runApp(const ReminderApp());
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS Reminder',
      theme: ThemeData(
        colorSchemeSeed: Colors.blueAccent,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blueAccent,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const HomePage(title: 'GPS Reminder'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

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
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
            bottom: const TabBar(
              tabs: <Widget> [
                Tab(icon: Icon(Icons.task_alt)),
                Tab(icon: Icon(Icons.location_pin)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              RemindersPage(),
              LocationsPage(),
              SettingsPage(),
            ],
          ),
        )
    );
  }
}
