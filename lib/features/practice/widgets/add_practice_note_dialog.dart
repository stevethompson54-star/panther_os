import 'package:flutter/material.dart';

Future<String?> showAddPracticeNoteDialog(
  BuildContext context,
) async {
  final controller = TextEditingController();

  final result = await showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Add Practice Note'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Enter your coaching note...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(
                dialogContext,
                controller.text,
              );
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );

  controller.dispose();

  return result;
}
