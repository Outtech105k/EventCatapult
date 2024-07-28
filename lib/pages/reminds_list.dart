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
  RemindWithPlace? _nextRemind;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black
                  ),
                ),
                height: 100,
                child: StreamBuilder<RemindWithPlace?>(
                  stream: widget.database.watchNextUpcomingRemind(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasData && snapshot.data != null) {
                      return Row(
                        children: [
                          Center(
                            child: Text(snapshot.data!.remind.name),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text("ここには、直近イベントに関する詳細が表示されます"),
                      );
                    }
                  },
                )
              ),
            ),

            Expanded(
                child: SeparatedStreamList<RemindWithPlace>(
                  stream: widget.database.watchAllRemindsWithPlaces(),
                  itemBuilder: (context, record) {
                    return ListTile(
                      // リマインド情報の表示
                      // TODO: 充実化
                      title: Text(record.remind.name),
                      subtitle: Text("${DateFormat('yyyy-MM-dd HH:mm').format(record.remind.deadline)}\n${record.place.name}"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RemindPage(database: widget.database, remind: record.remind)),
                        );
                      },
                    );
                  },
                )
            ),

          ],
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
