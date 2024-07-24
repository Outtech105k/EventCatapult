/*
 * PlaceMapPage
 * GoogleMapを描画し, 地点を指定するページ
 */

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'place_edit.dart';
import '../database/database.dart';

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
  GoogleMapController? _controller;
  LatLng? _currentPosition;
  final Location _location = Location();
  final Set<Marker> _markers = {};
  Marker? _pinnedMarker;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  // 現在地の取得
  Future<void> _fetchLocation() async {
    var locationData = await _location.getLocation();
    setState(() {
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
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
                          position: _currentPosition!,
                          database: widget.database,
                        ),
                    ),
                );
              },
              child: const Text("次へ"),
            )
          ],
        ),

        // マップの描画準備ができていなければ、ローディング画面を表示する
        body: _currentPosition == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [

            // 検索窓
            // TODO: 実装
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "場所を検索",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            // GoogleMap本体
            Expanded(
              child: GoogleMap(
                // 初期状態で現在地
                // TODO: ページ初期値で表示地点を指定されていれば、そこに移動
                initialCameraPosition: CameraPosition(
                  target: _currentPosition!,
                  zoom: 15.0,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },

                markers: _markers,
                // 長押しでピンを立てる(すでに立ててあれば置き換える)
                onLongPress: (latLng) {
                  setState(() {
                    _markers.remove(_pinnedMarker);
                    _pinnedMarker = Marker(
                      markerId: MarkerId(latLng.toString()), // TODO: 適切な一時的IDを設定
                      position: latLng,
                    );
                    _markers.add(_pinnedMarker!);
                  });
                },
              ),
            )
          ],
        )
    );
  }
}
