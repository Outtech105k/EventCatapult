/*
 * HomePage
 * アプリのルートページ, ここにはTabしか配置しない
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../database/database.dart';
import '../services/location.dart';

import 'reminds_list.dart';
import 'places_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,   // アプリタイトル
    required this.database // DBハンドラ
  });

  final String title;
  final AppDatabase database;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // 描画完了後、権限の許可をチェック(許可されていなければ許可させる)
    // TODO: 権限要求ページへの遷移
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
              RemindsListPage(database: widget.database),
              const PlacesListPage(),
            ],
          ),
        )
    );
  }
}
