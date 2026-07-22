import 'package:flutter/material.dart';

enum StatusType { success, warning, error, information }

class StatusTile extends StatelessWidget {
  const StatusTile({super.key, required this.label, required this.status});

  final String label;
  final StatusType status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = _appearanceFor(status);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(appearance.icon, size: 20, color: appearance.color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: appearance.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  _StatusAppearance _appearanceFor(StatusType status) {
    switch (status) {
      case StatusType.success:
        return const _StatusAppearance(
          icon: Icons.check_circle_outline,
          color: Colors.greenAccent,
        );

      case StatusType.warning:
        return const _StatusAppearance(
          icon: Icons.warning_amber_rounded,
          color: Colors.amber,
        );

      case StatusType.error:
        return const _StatusAppearance(
          icon: Icons.error_outline,
          color: Colors.redAccent,
        );

      case StatusType.information:
        return const _StatusAppearance(
          icon: Icons.info_outline,
          color: Colors.lightBlueAccent,
        );
    }
  }
}

class _StatusAppearance {
  const _StatusAppearance({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}
