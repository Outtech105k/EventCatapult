import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'location_edit.dart';

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
              onPressed: _lastPinnedMarker==null
                  ? null
                  : () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LocationEdit(),
                    ),
                );
              },
              child: const Text("次へ"),
            )
          ],
        ),
        body: _currentPosition == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "場所を検索",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (value) {
                  print(value);
                },
              ),
            ),
            Expanded(
              child: GoogleMap(
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
            )
          ],
        )
    );
  }
}
