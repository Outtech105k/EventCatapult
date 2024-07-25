/*
 * RemindsListPage
 * リマインド一覧を表示するページ
 */

import 'package:flutter/material.dart';

import 'remind.dart';
import 'remind_edit.dart';
import '../database/database.dart';
import '../widgets/separated_stream_list.dart';

class RemindsListPage extends StatefulWidget {
  const RemindsListPage({
    super.key,
    required this.database,
  });

  final AppDatabase database;

  @override
  State<RemindsListPage> createState() => _RemindsListPageState();
}

class _RemindsListPageState extends State<RemindsListPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: SeparatedStreamList<Remind>(
          stream: watchAllReminds(widget.database),
          itemBuilder: (context, remind) {
            return ListTile(
              // リマインド情報の表示
              // TODO: 充実化
              title: Text(remind.name),
              subtitle: Text(remind.id.toString()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RemindPage(database: widget.database, remind: remind)),
                );
              },
            );
          },
        ),

        // リマインダ追加ボタン
        // TODO: 追加ページ作成・遷移実装
        floatingActionButton: FloatingActionButton(
          tooltip: "リマインダーを追加",
          child: const Icon(Icons.notification_add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RemindEditPage(database: widget.database),
              )
            );
          },
        ),
      ),
    );
  }
}
