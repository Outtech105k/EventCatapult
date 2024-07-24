import 'package:flutter/material.dart';

class LocationEdit extends StatefulWidget {
  const LocationEdit({super.key});

  @override
  State<LocationEdit> createState() => _LocationEditState();
}

class _LocationEditState extends State<LocationEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("場所の追加"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "名前",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "説明",
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        )
    );
  }
}
