/*
 * RemindsListPage
 * リマインド一覧を表示するページ
 */

import 'dart:async';

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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

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
                  height: 70,
                  child: StreamBuilder<RemindWithPlace?>(
                    stream: widget.database.watchNextUpcomingRemind(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasData && snapshot.data != null) {
                        final remind = snapshot.data!.remind;
                        final now = DateTime.now();
                        final deadline = remind.deadline;
                        final remainingTime = deadline.difference(now);

                        return Row(
                          children: [
                            Expanded(
                                child: Column(
                                  children: [
                                    Text("次のイベント開始まで"),
                                    Text(
                                        _formatDuration(remainingTime),
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ],
                              ),
                            )
                          ],
                        );
                      } else {
                        return const Center(
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
