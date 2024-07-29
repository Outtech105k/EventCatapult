/*
 * PlaceSelectPage
 * 登録地点リストを表示するページ
 */

import 'package:flutter/material.dart';

import '../database/database.dart';
import '../widgets/separated_stream_list.dart';

class PlaceSelectPage extends StatefulWidget {
  const PlaceSelectPage({
    super.key,
    required this.database,
    required this.onPlaceSelected,
  });

  final AppDatabase database;
  final Function(Place) onPlaceSelected;

  @override
  State<PlaceSelectPage> createState() => _PlaceSelectPageState();
}

class _PlaceSelectPageState extends State<PlaceSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("場所の選択"),
      ),
      body: SeparatedStreamList<Place>(
        stream: watchAllPlaces(widget.database),
        itemBuilder: (BuildContext context, Place place) {
          return ListTile(
            title: Text(place.name),
            subtitle: Text(place.description),
            onTap: () {
              widget.onPlaceSelected(place);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
