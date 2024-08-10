import 'package:flutter/material.dart';

class CancelableDialog extends StatefulWidget {
  const CancelableDialog({
    super.key,
    this.icon,
    required this.titleText,
    required this.bodyText,
    required this.confirmText,
    required this.onPressedConfirm,
  });

  final IconData? icon;
  final String titleText;
  final String bodyText;
  final String confirmText;
  final void Function() onPressedConfirm;

  @override
  State<CancelableDialog> createState() => _CancelableDialogState();
}

class _CancelableDialogState extends State<CancelableDialog> {
  @override
  Widget build(context) {
    return AlertDialog(
      title: Row(
        children: [
          if (widget.icon != null)
            Icon(widget.icon),
          Text(widget.titleText),
        ],
      ),
      content: Text(widget.bodyText),
      actions: [
        TextButton(
          child: const Text("キャンセル"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(widget.confirmText),
          onPressed: () {
            Navigator.pop(context);
            widget.onPressedConfirm();
          },
        )
      ],
    );
  }
}
