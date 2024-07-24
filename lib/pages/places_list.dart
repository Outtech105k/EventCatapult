/*
 * PlacesListPage
 * 登録地点リストを表示するページ
 */

import 'package:flutter/material.dart';

import 'place_map.dart';
import '../database/database.dart';
import '../widgets/separated_stream_list.dart';

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
      body: SeparatedStreamList<Place>(
        stream: watchAllPlaces(widget.database),
        itemBuilder: (BuildContext context, Place place) {
          return ListTile(
            title: Text(place.name),
            subtitle: Text(place.id.toString()),
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
