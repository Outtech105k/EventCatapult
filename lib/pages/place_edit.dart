/*
 * PlaceEditPage
 * 登録地点の名前・説明を編集するページ
 */

import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config.dart';
import '../database/database.dart';

class PlaceEditPage extends StatefulWidget {
  const PlaceEditPage({
    super.key,
    required this.position,
    required this.database,
  });

  final LatLng position;
  final AppDatabase database;

  @override
  State<PlaceEditPage> createState() => _PlaceEditPageState();
}

class _PlaceEditPageState extends State<PlaceEditPage> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController _nameController, _descriptionController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: "");
    _descriptionController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("場所の追加"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // 入力バリデーションを通過したら、データを登録する
                if (formKey.currentState!.validate()) {
                  insertPlace(widget.database, PlacesCompanion(
                    name: d.Value(_nameController.text),
                    description: d.Value(_descriptionController.text),
                    longitude: d.Value(widget.position.longitude),
                    latitude: d.Value(widget.position.latitude),
                  ));
                }
              },
            )
          ],
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [

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
                      return "名前は${PlacesConfig.descriptionMaxLength}文字以内にしてください";
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
