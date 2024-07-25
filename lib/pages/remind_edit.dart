/*
 * RemindEditPage
 * リマインド情報を編集するページ
 */

import 'package:flutter/material.dart';

import '../config.dart';
import '../database/database.dart';

class RemindEditPage extends StatefulWidget {
  const RemindEditPage({
    super.key,
    required this.database,
  });

  final AppDatabase database;

  @override
  State<RemindEditPage> createState() => _RemindEditPageState();
}

class _RemindEditPageState extends State<RemindEditPage> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController _nameController, _detailController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: "");
    _detailController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("リマインダーの設定"),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                // 入力バリデーションを通過したら、データを登録する
                if (formKey.currentState!.validate()) {
                  // TODO: 登録処理
                }
              },
            )
          ],
        ),
        // TODO: リマインダーへの必要時刻の入力
        body: Form(
          key: formKey,
          child: Column(
            children: [

              // リマインド名入力フォーム
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "リマインド名(必須)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value==null||value.isEmpty) {
                      return "名前は必須です";
                    }
                    if (value.length>RemindsConfig.nameMaxLength){
                      return "名前は${RemindsConfig.nameMaxLength}文字以内にしてください";
                    }
                    return null;
                  },
                  controller: _nameController,
                ),
              ),

              // 詳細情報入力フォーム(空白可)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "詳細情報",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value != null && value.length > RemindsConfig.detailMaxLength){
                      return "詳細情報は${RemindsConfig.detailMaxLength}文字以内にしてください";
                    }
                    return null;
                  },
                  controller: _detailController,
                ),
              ),

            ],
          ),
        )
    );
  }
}
