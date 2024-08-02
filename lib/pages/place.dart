/*
 * PlacePage
 * 登録地点情報を確認するページ
 */

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'place_edit.dart';

import '../widgets/map.dart';
import '../database/database.dart';

class PlacePage extends StatefulWidget {
  const PlacePage({
    super.key,
    required this.database,
    required this.place, // 表示すべき地点情報
  });

  final AppDatabase database;
  final Place place;

  @override
  State<PlacePage> createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("登録地点の内容"),
          actions: [
            // 編集ボタン
            IconButton(
              icon: const Icon(Icons.edit_location_alt),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceEditPage(
                      database: widget.database,
                      initialPlace: widget.place,
                    )
                  )
                );
              },
            ),

            // 削除ボタン
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: (){
                Navigator.pop(context);
                deletePlace(widget.database, widget.place);
              },
            )
          ],
        ),

        body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 300,
                  child: Map(
                    initPosition: LatLng(
                      widget.place.latitude,
                      widget.place.longitude
                    ),
                  ),
                ),

                // 地点名
                Text(
                    widget.place.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // 地点情報
                Text(widget.place.description)
              ],
            )
        )
    );
  }
}
