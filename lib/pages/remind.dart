/*
 * RemindPage
 * リマインド情報を確認するページ
 */

import 'package:flutter/material.dart';

import '../database/database.dart';

class RemindPage extends StatefulWidget {
  const RemindPage({
    super.key,
    required this.database,
    required this.remind,
  });

  final AppDatabase database;
  final Remind remind;

  @override
  State<RemindPage> createState() => _RemindPageState();
}

class _RemindPageState extends State<RemindPage> {
  @override
  void initState() {
    super.initState();
  }

  // TODO: 充実化
  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("リマインドの内容"),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: (){
                Navigator.pop(context);
                deleteRemind(widget.database, widget.remind);
              },
            )
          ],
        ),
        body: Center(
            child: Column(
              children: <Widget>[
                Text(
                  widget.remind.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
        )
    );
  }
}
