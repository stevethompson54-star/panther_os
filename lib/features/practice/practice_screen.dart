import 'package:flutter/material.dart';

import '../../design_system/panther_scaffold.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PantherScaffold(
      title: 'PRACTICE MODE',
      subtitle: 'Run today’s training session from one focused workspace.',
      showBackButton: true,
      maxContentWidth: 900,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSessionHeader(theme),
          const SizedBox(height: 20),
          _buildCurrentBlockCard(theme),
          const SizedBox(height: 16),
          _buildNextBlockCard(theme),
          const SizedBox(height: 16),
          _buildTeamStatusCard(theme),
          const SizedBox(height: 24),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSessionHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.5),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: 10,
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(
            '00:00:00',
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'SESSION TIMER',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'High Press & Transition Recovery',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Tuesday • 6:00 PM • 90 Minutes',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBlockCard(ThemeData theme) {
    return _DashboardCard(
      eyebrow: 'CURRENT BLOCK',
      icon: Icons.play_circle_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activation',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            'Dynamic Warm-Up + Rondo',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 18),
          const _InformationRow(
            icon: Icons.schedule,
            label: 'Block Duration',
            value: '12 Minutes',
          ),
          const SizedBox(height: 12),
          const _InformationRow(
            icon: Icons.timer_outlined,
            label: 'Time Remaining',
            value: '12:00',
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                debugPrint('Start Block pressed');
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('START BLOCK'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextBlockCard(ThemeData theme) {
    return _DashboardCard(
      eyebrow: 'NEXT BLOCK',
      icon: Icons.skip_next_outlined,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Passing Patterns',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Technical Development',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '15 MIN',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamStatusCard(ThemeData theme) {
    return _DashboardCard(
      eyebrow: 'TEAM STATUS',
      icon: Icons.groups_outlined,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useTwoColumns = constraints.maxWidth >= 620;

          const leftColumn = Column(
            children: [
              _InformationRow(
                icon: Icons.people_outline,
                label: 'Players Present',
                value: '13 / 15',
              ),
              SizedBox(height: 14),
              _InformationRow(
                icon: Icons.sports_soccer,
                label: 'Soccer Balls',
                value: '18',
              ),
              SizedBox(height: 14),
              _InformationRow(
                icon: Icons.checkroom_outlined,
                label: 'Pinnies',
                value: 'Ready',
              ),
            ],
          );

          const rightColumn = Column(
            children: [
              _InformationRow(
                icon: Icons.sports_outlined,
                label: 'Goals',
                value: 'Ready',
              ),
              SizedBox(height: 14),
              _InformationRow(
                icon: Icons.wb_sunny_outlined,
                label: 'Weather',
                value: '76°F',
              ),
              SizedBox(height: 14),
              _InformationRow(
                icon: Icons.water_drop_outlined,
                label: 'Hydration',
                value: 'Ready',
              ),
            ],
          );

          if (useTwoColumns) {
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: leftColumn),
                SizedBox(width: 32),
                Expanded(child: rightColumn),
              ],
            );
          }

          return const Column(
            children: [
              leftColumn,
              SizedBox(height: 14),
              rightColumn,
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              debugPrint('Next Block pressed');
            },
            icon: const Icon(Icons.skip_next),
            label: const Text('NEXT BLOCK'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              debugPrint('Pause Practice pressed');
            },
            icon: const Icon(Icons.pause),
            label: const Text('PAUSE PRACTICE'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () {
              debugPrint('End Practice pressed');
            },
            icon: const Icon(Icons.stop_circle_outlined),
            label: const Text('END PRACTICE'),
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          label: const Text('RETURN TO MISSION CONTROL'),
        ),
      ],
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.eyebrow,
    required this.icon,
    required this.child,
  });

  final String eyebrow;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 9),
              Text(
                eyebrow,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}