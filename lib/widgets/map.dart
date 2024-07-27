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
    this.initPosition,
    required this.isPinEditable,
    this.onMarkerPinned,
  });

  final LatLng? initPosition;
  final bool isPinEditable;
  final Function(Marker)? onMarkerPinned;

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  LatLng? _initPosition;
  final Location _location = Location();
  final Set<Marker> _markers = {};
  Marker? _pinnedMarker;

  @override
  void initState() {
    super.initState();
    _initMapPosition();
  }

  Future<void> _initMapPosition() async {
    if (widget.initPosition == null) {
      var locationData = await _location.getLocation();
      setState(() {
        _initPosition = LatLng(locationData.latitude!, locationData.longitude!);
      });
    } else {
      setState(() {
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
        /*
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
             */
        Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initPosition!,
              zoom: 15.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,

            markers: _markers,
            onLongPress: (latLng) {
              if (widget.isPinEditable) {
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
