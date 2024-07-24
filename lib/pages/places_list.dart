/*
 * PlacesListPage
 * 登録地点リストを表示するページ
 */

import 'package:flutter/material.dart';

import 'place_map.dart';
import '../database/database.dart';

class PlacesListPage extends StatefulWidget {
  const PlacesListPage({
    super.key,
    required this.database,
  });

  final AppDatabase database;

  @override
  State<PlacesListPage> createState() => _PlacesListPageState();
}

// TODO: 充実化
class _PlacesListPageState extends State<PlacesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Place>>(
        stream: watchAllPlaces(widget.database),
        builder: (context, snapshot) {
          final places = snapshot.data ?? [];
          return ListView.separated(
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return ListTile(
                title: Text(place.name),
                subtitle: Text(place.id.toString()),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
          );
        },
      ),

      // 登録地点追加ボタン
      floatingActionButton: FloatingActionButton(
        tooltip: "場所の登録",
        child: const Icon(Icons.add_location),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlaceMapPage(
                  database: widget.database,
                ),
            ),
          );
        },
      ),
    );
  }
}
