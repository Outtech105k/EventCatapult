/*
 * RemindEditPage
 * リマインド情報を編集するページ
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as d;
import 'package:flutter_localizations/flutter_localizations.dart';

import '../config.dart';
import '../database/database.dart';
import 'place_select.dart';

class RemindEditPage extends StatefulWidget {
  const RemindEditPage({
    super.key,
    required this.database,
    this.initialRemind, // 初期状態リマインド(新規作成時null)
  });

  final AppDatabase database;
  final Remind? initialRemind;

  @override
  State<RemindEditPage> createState() => _RemindEditPageState();
}

class _RemindEditPageState extends State<RemindEditPage> {
  final _formKey = GlobalKey<FormState>(); // フォームバリデーションキー

  Place? _remindPlace;
  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;
  late TextEditingController _nameController, _detailController;

  @override
  void initState() {
    super.initState();

    // リマインドの初期値があれば(編集モード)設定
    _nameController = TextEditingController(text: widget.initialRemind?.name ?? "");
    _detailController = TextEditingController(text: widget.initialRemind?.detail ?? "");

    if (widget.initialRemind != null) {
      Remind remind = widget.initialRemind!;

      // 地点IDから座標をルックアップ
      selectPlaceById(widget.database, remind.placeId).then((place) {
        setState(() {
          _remindPlace = place;
        });
      });

      // 日時ピッカーへのセット
      _pickedDate = DateTime(
        remind.deadline.year,
        remind.deadline.month,
        remind.deadline.day,
      );
      _pickedTime = TimeOfDay(
        hour: remind.deadline.hour,
        minute: remind.deadline.minute,
      );
    }
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
                // 入力バリデーションを通過したら、データをUPSERTする
                // TODO: バリデーション違反時のメッセージボックス
                if (_formKey.currentState!.validate() && _remindPlace!=null && _pickedDate != null && _pickedTime != null) {
                  upsertRemind(widget.database, RemindsCompanion(
                      id: widget.initialRemind == null
                          ? const d.Value.absent()             // INSERT時
                          : d.Value(widget.initialRemind!.id), // UPDATE時
                      name: d.Value(_nameController.text),
                      detail: d.Value(_detailController.text),
                      placeId: d.Value(_remindPlace!.id),
                      deadline: d.Value(DateTime(
                          _pickedDate!.year, _pickedDate!.month, _pickedDate!.day, _pickedTime!.hour, _pickedTime!.minute
                      ))
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(widget.initialRemind==null ? "登録しました" : "変更しました"))
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst); // 登録後、初期画面まで戻る
                }
              },
            )
          ],
        ),

        body: Form(
          key: _formKey,
          child: Column(
            // TODO: 全部Padding
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

              // 登録地点選択ボタン
              // TODO: 長押しして地点情報ページ
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
                        Text(_remindPlace?.name ?? "未選択"),
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
                                      _remindPlace = place;
                                    });
                                  }
                              )
                          )
                      );
                    },
                  )
              ),

              // 日時指定ボタン
              // TODO: 一般化して`../widgets/`に作成
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
                        DateTime? date = await showDatePicker(
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                            locale: const Locale("ja"),
                            context: context,
                            initialDate: _pickedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100)
                        );
                        if (date!=null){
                          setState(() {
                            _pickedDate = date;
                          });
                        }
                      },
                      child: Text(
                          _pickedDate != null
                              ? DateFormat("yyyy-MM-dd").format(_pickedDate!)
                              : "???? - ?? - ??"
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      onPressed: () async {
                        TimeOfDay? time = await showTimePicker(
                          helpText: "時間を選択",
                          initialEntryMode: TimePickerEntryMode.dialOnly,
                          context: context,
                          initialTime: _pickedTime ?? TimeOfDay.now(),
                        );
                        if (time != null){
                          setState(() {
                            _pickedTime = time;
                          });
                        }
                      },
                      child: Text(_pickedTime?.format(context) ?? "?? : ??"),
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
