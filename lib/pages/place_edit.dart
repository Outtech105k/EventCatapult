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
    this.initialPlace, // 登録地点の初期値(新規データならnull指定)
  });

  final AppDatabase database;
  final Place? initialPlace;

  @override
  State<PlaceEditPage> createState() => _PlaceEditPageState();
}

class _PlaceEditPageState extends State<PlaceEditPage> {
  final formKey = GlobalKey<FormState>(); // 入力バリデーション用キー
  LatLng? _position;
  late TextEditingController _nameController, _descriptionController;

  @override
  void initState() {
    super.initState();

    // `widget.initialPlace`が設定済みなら、フォーム・地図の初期情報にセット
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
                // 入力バリデーションを通過したら、データをUPSERTする
                // TODO: バリデーション違反時のポップアップ
                if (formKey.currentState!.validate() && _position!=null) {
                  upsertPlace(widget.database, PlacesCompanion(
                    id: widget.initialPlace == null
                        ? const d.Value.absent()            // INSERT時
                        : d.Value(widget.initialPlace!.id), // UPDATE時
                    name: d.Value(_nameController.text),
                    description: d.Value(_descriptionController.text),
                    longitude: d.Value(_position!.longitude),
                    latitude: d.Value(_position!.latitude),
                  ));
                  Navigator.of(context).popUntil((route) => route.isFirst); // 地点リストまで戻す
                }
              },
            ),
          ],
        ),

        body: Form(
          key: formKey,
          child: Column(
            children: [
              // 地点指定フォーム(GoogleMap)
              Expanded(
                  child: Map(
                    isEditMode: true,
                    initPosition: _position,
                    onMarkerPinned: (marker) {
                      setState(() {
                        _position = marker.position;
                      });
                    },
                  ),
              ),

              // 地点名入力フォーム
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "地点名(必須)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value==null || value.isEmpty) {
                      return "名前は必須です";
                    }
                    if (value.length>PlacesConfig.nameMaxLength){
                      return "名前は${PlacesConfig.nameMaxLength}文字以内にしてください";
                    }
                    return null;
                  },
                ),
              ),

              // 説明入力フォーム(空白可)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _descriptionController,
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
                ),
              ),
            ],
          ),
        )
    );
  }
}
