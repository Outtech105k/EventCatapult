import 'package:flutter/material.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        body: const Center(
          child: Text("Reminders"),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "リマインダーを追加",
          child: const Icon(Icons.add_task),
          onPressed: () {
          },
        ),
      ),
    );
  }
}
