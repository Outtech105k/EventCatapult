/*
 * RemindsListPage
 * リマインド一覧を表示するページ
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        body: Column(
          children: [
            // TODO: 先頭リマインドに関するヘッダー
            // TODO: 時刻を過ぎたリマインダーの対処(到着・未到着関係なく)

            // リマインド一覧
            Expanded(
              child: SeparatedStreamList<RemindWithPlace>(
                stream: widget.database.watchAllRemindsWithPlaces(),
                itemBuilder: (context, record) {
                  return ListTile(
                    title: Text(record.remind.name),
                    subtitle: Text(
                      "${DateFormat('yyyy/MM/dd HH:mm').format(record.remind.deadline)}\n${record.place.name}",
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RemindPage(
                            database: widget.database,
                            remindWithPlace: record,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),

        // リマインダ追加ボタン
        floatingActionButton: FloatingActionButton(
          tooltip: "リマインダーを追加",
          child: const Icon(Icons.notification_add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RemindEditPage(database: widget.database),
              ),
            );
          },
        ),
      ),
    );
  }
}
