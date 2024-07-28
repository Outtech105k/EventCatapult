/*
 * RemindEditPage
 * リマインド情報を編集するページ
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as d;

import '../config.dart';
import '../database/database.dart';
import 'place_select.dart';

class RemindEditPage extends StatefulWidget {
  const RemindEditPage({
    super.key,
    required this.database,
    this.initialRemind,
  });

  final AppDatabase database;
  final Remind? initialRemind;

  @override
  State<RemindEditPage> createState() => _RemindEditPageState();
}

class _RemindEditPageState extends State<RemindEditPage> {
  final formKey = GlobalKey<FormState>();

  Place? remindPlace;
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  late TextEditingController _nameController, _detailController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.initialRemind?.name ?? "");
    _detailController = TextEditingController(text: widget.initialRemind?.detail ?? "");
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
                if (formKey.currentState!.validate() && remindPlace!=null && pickedDate != null && pickedTime != null) {
                  upsertRemind(widget.database, RemindsCompanion(
                    id: widget.initialRemind == null
                        ? const d.Value.absent()
                        : d.Value(widget.initialRemind!.id),
                    name: d.Value(_nameController.text),
                    detail: d.Value(_detailController.text),
                    placeId: d.Value(remindPlace!.id),
                    deadline: d.Value(DateTime(
                      pickedDate!.year, pickedDate!.month, pickedDate!.day, pickedTime!.hour, pickedTime!.minute
                    ))
                  ));
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

              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.place),
                        Text(remindPlace?.name ?? "未選択"),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlaceSelectPage(
                                database: widget.database,
                                onPlaceSelected: (place) {
                                  setState(() {
                                    remindPlace = place;
                                  });
                                }
                            )
                        )
                      );
                    },
                  )
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      onPressed: () async {
                        DateTime? date = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
                        if (date!=null){
                          setState(() {
                            pickedDate = date;
                          });
                        }
                      },
                      child: Text(
                        pickedDate != null
                            ? "${pickedDate!.year}/${pickedDate!.month}/${pickedDate!.day}"
                            : "????/??/??"
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      onPressed: () async {
                        TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if (time != null){
                          setState(() {
                            pickedTime = time;
                          });
                        }
                      },
                      child: Text(pickedTime?.format(context) ?? "?? : ??"),
                    ),
                  ],
                ),
              )

            ],
          ),
        )
    );
  }
}
