/*
 * PlaceMapPage
 * GoogleMapを描画し, 地点を指定するページ
 */

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'place_edit.dart';
import '../database/database.dart';
import '../widgets/map.dart';

class PlaceMapPage extends StatefulWidget {
  const PlaceMapPage({
    super.key,
    required this.database,
  });

  final AppDatabase database;

  @override
  State<PlaceMapPage> createState() => _PlaceMapPageState();
}

class _PlaceMapPageState extends State<PlaceMapPage> {
  final Location _location = Location();
  final Set<Marker> _markers = {};
  Marker? _pinnedMarker;

  void _updateMarker(Marker newMarker) {
    setState(() {
      _pinnedMarker = newMarker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("場所の追加"),
        actions: [
          TextButton(
            // ピンが立っていなければ, 次に進むボタンを無効化
            // TODO: 立っていれば, 次の画面に座標を渡す
            onPressed: _pinnedMarker==null
                ? null
                : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaceEditPage(
                    position: _pinnedMarker!.position,
                    database: widget.database,
                  ),
                ),
              );
            },
            child: const Text("次へ"),
          )
        ],
      ),

      body: Map(
        isPinEditable: true,
        onMarkerPinned: _updateMarker,
      ),
    );
  }
}
