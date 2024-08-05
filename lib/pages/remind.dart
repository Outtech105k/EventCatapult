/*
 * RemindPage
 * リマインド情報を確認するページ
 */

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../database/database.dart';
import 'remind_edit.dart';
import '../widgets/map.dart';

class RemindPage extends StatefulWidget {
  const RemindPage({
    super.key,
    required this.database,
    required this.remindWithPlace,
  });

  final AppDatabase database;
  final RemindWithPlace remindWithPlace;

  @override
  State<RemindPage> createState() => _RemindPageState();
}

class _RemindPageState extends State<RemindPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("リマインドの内容"),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_notifications),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RemindEditPage(
                          database: widget.database,
                          initialRemind: widget.remindWithPlace.remind,
                        )
                    )
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("リマインドを削除"),
                      content: Text("リマインド \"${widget.remindWithPlace.remind.name}\" を削除しますか？"),
                      actions: [
                        TextButton(
                          child: const Text("キャンセル"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: const Text("削除"),
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            deleteRemind(widget.database, widget.remindWithPlace.remind);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("削除しました"))
                            );
                          },
                        ),
                      ],
                    );
                  }
                );
              },
            ),
          ],
        ),
        body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 300,
                  child: Map(
                    initPosition: LatLng(
                        widget.remindWithPlace.place.latitude,
                        widget.remindWithPlace.place.longitude
                    ),
                  ),
                ),

                Text(
                  widget.remindWithPlace.remind.name,
                  style: const TextStyle(fontSize: 30),
                ),
                Text(
                  "@${widget.remindWithPlace.place.name}",
                  style: const TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Text(widget.remindWithPlace.remind.detail),
                  ),
                )


              ],
            )
        )
    );
  }
}
