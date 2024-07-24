/*
 * PlacesListPage
 * 登録地点リストを表示するページ
 */

import 'package:flutter/material.dart';

import 'place_map.dart';

class PlacesListPage extends StatefulWidget {
  const PlacesListPage({super.key});

  @override
  State<PlacesListPage> createState() => _PlacesListPageState();
}

// TODO: 充実化
class _PlacesListPageState extends State<PlacesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Locations"),
      ),

      // 登録地点追加ボタン
      floatingActionButton: FloatingActionButton(
        tooltip: "場所の登録",
        child: const Icon(Icons.add_location),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PlaceMapPage(),
            ),
          );
        },
      ),
    );
  }
}
