import 'package:flutter/material.dart';
import '../database/reminds.dart';
import 'remind.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({
    super.key,
    required this.database,
  });

  final AppDatabase database;

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
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
