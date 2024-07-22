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
  State<RemindPage> createState() => _RemindState();
}

class _RemindState extends State<RemindPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("リマインダーの内容"),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: (){},
            )
          ],
        ),
        body: Center(
            child: Column(
              children: <Widget>[
                Text(
                    widget.remind.title,
                  style: TextStyle(
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
