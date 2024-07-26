/*
 * Map
 * GoogleMapを表示するウィジェット
 */

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Map extends StatefulWidget {
  const Map({
    super.key,
    this.isPlaceShowMode = true,
    this.initPosition,
    this.onMarkerPinned,
  });

  final bool isPlaceShowMode;
  final LatLng? initPosition; // 表示の初期位置を設定
  final Function(Marker)? onMarkerPinned; // ピンが立てられた(変更時含む)時のコールバック関数

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  LatLng? _initPosition; // 地図表示時の初期地点
  final Set<Marker> _markers = {}; // 表示するマーカー
  Marker? _pinnedMarker; // ユーザーに表示または設定させるピン

  @override
  void initState() {
    super.initState();
    _initMapPosition();
  }

  Future<void> _initMapPosition() async {
    if (widget.initPosition == null) {
      // 初期位置未設定時: 現在地を初期位置とする
      var locationData = await Location().getLocation();
      setState(() {
        _initPosition = LatLng(locationData.latitude!, locationData.longitude!);
      });
    } else {
      setState(() {
        // 初期位置設定時: 初期位置にピンを立てる
        _initPosition = LatLng(widget.initPosition!.latitude, widget.initPosition!.longitude);
        _pinnedMarker = Marker(
          markerId: MarkerId(_initPosition.toString()), // TODO: 適切な一時的IDを設定
          position: _initPosition!,
        );
        _markers.add(_pinnedMarker!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _initPosition == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
      children: [
        // 検索窓
        // TODO: 完全な実装 & remove false
        if (!widget.isPlaceShowMode && false)
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
        Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initPosition!,
              zoom: 15.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: !widget.isPlaceShowMode, // 現在地ボタンは場所編集モードのみで許可
            mapType: MapType.normal,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,

            markers: _markers,
            onLongPress: (latLng) {
              if (!widget.isPlaceShowMode) {
                setState(() {
                  _markers.remove(_pinnedMarker);
                  _pinnedMarker = Marker(
                    markerId: MarkerId(latLng.toString()), // TODO: 適切な一時的IDを設定
                    position: latLng,
                  );
                  _markers.add(_pinnedMarker!);
                  if (widget.onMarkerPinned != null){
                    widget.onMarkerPinned!(_pinnedMarker!);
                  }
                });
              }
            },
          ),
        )
      ],
    );
  }
}
