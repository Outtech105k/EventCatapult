/*
 * RemindsListPage
 * リマインド一覧を表示するページ
 */

import 'package:flutter/material.dart';

import 'remind.dart';
import '../database/database.dart';

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
        body: StreamBuilder<List<Remind>>(
          stream: watchAllReminds(widget.database),
          builder: (context, snapshot) {
            final reminds = snapshot.data ?? [];
            return ListView.separated(
              itemCount: reminds.length,
              itemBuilder: (context, index) {
                final remind = reminds[index];
                  return ListTile(
                    // リマインド情報の表示
                    // TODO: 充実化
                    title: Text(remind.title),
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
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
                thickness: 1.0,
              )
            );
          },
        ),

        // リマインダ追加ボタン
        // TODO: 追加ページ作成・遷移実装
        floatingActionButton: FloatingActionButton(
          tooltip: "リマインダーを追加",
          child: const Icon(Icons.notification_add),
          onPressed: () async {
            await insertRemind(widget.database, Remind(id: DateTime.now().millisecondsSinceEpoch, title: "Test Title", content: "CONTENT"));
          },
        ),
      ),
    );
  }
}
