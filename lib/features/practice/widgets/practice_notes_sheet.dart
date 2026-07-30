import 'package:flutter/material.dart';

import '../controllers/practice_controller.dart';
import 'add_practice_note_dialog.dart';

Future<void> showPracticeNotesSheet({
  required BuildContext context,
  required PracticeController controller,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);

      return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.note_alt_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Practice Notes',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      '${controller.practiceNoteCount}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(
                  color: theme.colorScheme.outlineVariant,
                  height: 1,
                ),
                const SizedBox(height: 24),
                if (controller.practiceNotes.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.edit_note,
                          size: 48,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No practice notes yet.',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Notes added during practice will appear here.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...controller.practiceNotes.map(
  (note) {
    final hour = note.createdAt.hour;
    final minute = note.createdAt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.circle, size: 8),
      title: Text(note.text),
      subtitle: Text(
        '$displayHour:$minute $period',
      ),
    );
  },
),
                const SizedBox(height: 16),
                OutlinedButton.icon(
  onPressed: () async {
    final note = await showAddPracticeNoteDialog(
      sheetContext,
    );

    if (note == null) {
      return;
    }

    controller.addPracticeNote(note);
  },
  icon: const Icon(Icons.add),
  label: const Text('ADD NOTE'),
),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: const Text('DONE'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
