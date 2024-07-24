/*
 * PlaceEditPage
 * 登録地点の名前・説明を編集するページ
 */

import 'package:flutter/material.dart';

class PlaceEditPage extends StatefulWidget {
  const PlaceEditPage({super.key});

  @override
  State<PlaceEditPage> createState() => _PlaceEditPageState();
}

class _PlaceEditPageState extends State<PlaceEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("場所の追加"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
              },
            )
          ],
        ),
        body: Form(
          child: Column(
            children: [

              // 地点名入力フォーム
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "名前",
                    border: OutlineInputBorder(),
                  ),
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
                ),
              ),

            ],
          ),
        )
    );
  }
}
