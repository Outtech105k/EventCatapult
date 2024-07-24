/*
 * PlacePage
 * 登録地点情報を確認するページ
 */

import 'package:flutter/material.dart';

import '../database/database.dart';

class PlacePage extends StatefulWidget {
  const PlacePage({
    super.key,
    required this.database,
    required this.place,
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

  // TODO: 充実化
  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("登録地点の内容"),
          actions: [
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
                Text(
                    widget.place.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(widget.place.description)
              ],
            )
        )
    );
  }
}
