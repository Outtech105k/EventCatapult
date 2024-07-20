import 'package:flutter/material.dart';
import 'map.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Locations"),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "場所の登録",
        child: const Icon(Icons.add_location),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: const Text("場所の登録"),
                  ),
                  body: const Map(),
                )
            ),
          );
        },
      ),
    );
  }
}
