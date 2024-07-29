/*
 * RemindsListPage
 * リマインド一覧を表示するページ
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'remind.dart';
import 'remind_edit.dart';
import '../database/database.dart';
import '../widgets/separated_stream_list.dart';
import '../services/search_route.dart';

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
  bool _hasFetchedNextEvent = false;
  DateTime? _departureDeadline; // 出発リミット目安を保持する変数

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
    String twoDigits(int n) => n.abs().toString().padLeft(2, '0');
    final isNegative = duration.isNegative;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final formattedDuration = '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';

    return isNegative ? '-$formattedDuration' : formattedDuration;
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
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
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
                      if (!_hasFetchedNextEvent) {
                        _hasFetchedNextEvent = true;
                        searchDriveRouteFromCurrent(
                          LatLng(snapshot.data!.place.latitude, snapshot.data!.place.longitude),
                          snapshot.data!.remind.deadline,
                        ).then((routes) {
                          int seconds = int.parse(routes[0].duration.replaceAll('s', ''));
                          Duration duration = Duration(seconds: seconds);
                          setState(() {
                            _departureDeadline = snapshot.data!.remind.deadline.subtract(duration); // 計算結果をセット
                          });
                        });
                      }
                      final remind = snapshot.data!.remind;
                      final now = DateTime.now();
                      final deadline = remind.deadline;
                      final remainingTime = deadline.difference(now);
                      final departureRemainingTime = _departureDeadline?.difference(now);

                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text("次のイベント開始まで"),
                                Text(
                                  _formatDuration(remainingTime),
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text("出発リミット目安まで"),
                                Text(
                                  departureRemainingTime != null
                                      ? _formatDuration(departureRemainingTime)
                                      : "--:--:--",
                                  style: departureRemainingTime==null || !_formatDuration(departureRemainingTime).startsWith('-')
                                      ? const TextStyle(
                                      fontSize: 30
                                  )
                                      : const TextStyle(
                                    fontSize: 30,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text("ここには、直近イベントに関する詳細が表示されます"),
                      );
                    }
                  },
                ),
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
                    subtitle: Text(
                      "${DateFormat('yyyy-MM-dd HH:mm').format(record.remind.deadline)}\n${record.place.name}",
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
