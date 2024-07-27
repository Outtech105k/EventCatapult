/*
 * ListWidgets
 */

import 'package:flutter/material.dart';

class SeparatedStreamList <T> extends StatelessWidget {
  const SeparatedStreamList({
    super.key,
    required this.stream,
    required this.itemBuilder,
  });

  final Stream<List<T>> stream;
  final ListTile Function(BuildContext context, T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>>(
      stream: stream,
      builder: (context, snapshot) {
        final records = snapshot.data ?? [];
        return records.isEmpty
            ? const Center(child: Text("データがありません"))
            : ListView.separated(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return itemBuilder(context, record); // REPLACE HERE
          },
          separatorBuilder: (context, index) => const Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
        );
      },
    );
  }
}
