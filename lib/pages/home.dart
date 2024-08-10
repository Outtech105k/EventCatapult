/*
 * HomePage
 * アプリのルートページ, ここにはTabしか配置しない
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database.dart';
import '../services/location.dart';

import 'reminds_list.dart';
import 'places_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,   // アプリタイトル
    required this.isFirstLaunch, // 初回起動か否か
    required this.database // DBハンドラ
  });

  final String title;
  final bool isFirstLaunch;
  final AppDatabase database;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (widget.isFirstLaunch) {
      firstLaunchDialog();
    }
  }

  Future<void> firstLaunchDialog() async {

    // 初回起動フラグを変更
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("is_first_launch", false);
  }

  @override
  Widget build(BuildContext context) {
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
              RemindsListPage(database: widget.database), // リマインダページ
              PlacesListPage(database: widget.database), // 登録地点ページ
            ],
          ),
        )
    );
  }
}
