/*
 * PlaceEditPage
 * 登録地点の名前・説明を編集するページ
 */

import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config.dart';
import '../database/database.dart';
import '../widgets/map.dart';

class PlaceEditPage extends StatefulWidget {
  const PlaceEditPage({
    super.key,
    required this.database,
    this.initialPlace,
  });

  final AppDatabase database;
  final Place? initialPlace;

  @override
  State<PlaceEditPage> createState() => _PlaceEditPageState();
}

class _PlaceEditPageState extends State<PlaceEditPage> {
  final formKey = GlobalKey<FormState>();
  LatLng? _position;
  late TextEditingController _nameController, _descriptionController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.initialPlace?.name ?? "");
    _descriptionController = TextEditingController(text: widget.initialPlace?.description ?? "");
    if (widget.initialPlace != null) {
      _position = LatLng(widget.initialPlace!.latitude, widget.initialPlace!.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("場所の設定"),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                // 入力バリデーションを通過したら、データを登録する
                if (formKey.currentState!.validate() && _position!=null) {
                  upsertPlace(widget.database, PlacesCompanion(
                    id: widget.initialPlace == null
                        ? const d.Value.absent()
                        : d.Value(widget.initialPlace!.id),
                    name: d.Value(_nameController.text),
                    description: d.Value(_descriptionController.text),
                    longitude: d.Value(_position!.longitude),
                    latitude: d.Value(_position!.latitude),
                  ));
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
            )
          ],
        ),

        body: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                  child: Map(
                    isEditMode: true,
                    initPosition: _position,
                    onMarkerPinned: (marker) {
                      setState(() {
                        _position = marker.position;
                      });
                    },
                  )
              ),

              // 地点名入力フォーム
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "地点名(必須)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value==null||value.isEmpty) {
                      return "名前は必須です";
                    }
                    if (value.length>PlacesConfig.nameMaxLength){
                      return "名前は${PlacesConfig.nameMaxLength}文字以内にしてください";
                    }
                    return null;
                  },
                  controller: _nameController,
                ),
              ),

              // 説明入力フォーム(空白可)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "説明",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value != null && value.length > PlacesConfig.descriptionMaxLength){
                      return "説明は${PlacesConfig.descriptionMaxLength}文字以内にしてください";
                    }
                    return null;
                  },
                  controller: _descriptionController,
                ),
              ),

            ],
          ),
        )
    );
  }
}
