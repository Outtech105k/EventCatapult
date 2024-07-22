import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPos extends StatefulWidget {
  const MapPos({super.key});

  @override
  State<MapPos> createState() => _MapPosState();
}

class _MapPosState extends State<MapPos> {
  GoogleMapController? _controller;
  LatLng? _currentPosition;
  final Location _location = Location();
  final Set<Marker> _markers = {};
  Marker? _lastPinnedMarker;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    var locationData = await _location.getLocation();
    setState(() {
      _currentPosition =
          LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("場所の追加"),
        actions: [
          TextButton(
            onPressed: _lastPinnedMarker==null
                ? null
                : () {
              print(_lastPinnedMarker!.position.toString());
            },
            child: const Text("次へ"),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
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
            onLongPress: (latLng) {
              setState(() {
                _markers.remove(_lastPinnedMarker);
                _lastPinnedMarker = Marker(
                  markerId: MarkerId(latLng.toString()),
                  position: latLng,
                );
                _markers.add(_lastPinnedMarker!);
              });
            },
          ),
        ],
      ),
    );
  }
}
