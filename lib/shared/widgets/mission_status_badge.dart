import 'package:flutter/material.dart';

enum MissionStatus { ready, attentionRequired, notReady }

class MissionStatusBadge extends StatelessWidget {
  const MissionStatusBadge({required this.status, super.key});

  final MissionStatus status;

  @override
  Widget build(BuildContext context) {
    final appearance = _appearanceFor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: appearance.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: appearance.color.withValues(alpha: 0.45)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(appearance.icon, size: 18, color: appearance.color),
          Text(
            appearance.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: appearance.color,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  _MissionStatusAppearance _appearanceFor(MissionStatus status) {
    switch (status) {
      case MissionStatus.ready:
        return const _MissionStatusAppearance(
          label: 'MISSION READY',
          icon: Icons.check_circle_outline,
          color: Color(0xFF52E5A1),
        );

      case MissionStatus.attentionRequired:
        return const _MissionStatusAppearance(
          label: 'ATTENTION REQUIRED',
          icon: Icons.warning_amber_rounded,
          color: Color(0xFFFFC629),
        );

      case MissionStatus.notReady:
        return const _MissionStatusAppearance(
          label: 'NOT READY',
          icon: Icons.error_outline,
          color: Color(0xFFFF6B6B),
        );
    }
  }
}

class _MissionStatusAppearance {
  const _MissionStatusAppearance({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}
