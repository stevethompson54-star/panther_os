import 'package:flutter/material.dart';

import '../../design_system/panther_scaffold.dart';
import 'models/practice_block.dart';
import 'models/practice_session.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = _createSampleSession();

    final currentBlock = session.blocks.first;
    final nextBlock =
        session.blocks.length > 1 ? session.blocks[1] : null;

    return PantherScaffold(
      title: 'PRACTICE MODE',
      subtitle: 'Run today’s training session from one focused workspace.',
      showBackButton: true,
      maxContentWidth: 900,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSessionHeader(
            theme: theme,
            session: session,
          ),
          const SizedBox(height: 20),
          _buildCurrentBlockCard(
            theme: theme,
            block: currentBlock,
          ),
          if (nextBlock != null) ...[
            const SizedBox(height: 16),
            _buildNextBlockCard(
              theme: theme,
              block: nextBlock,
            ),
          ],
          const SizedBox(height: 16),
          _buildSessionOverviewCard(
            theme: theme,
            session: session,
          ),
          const SizedBox(height: 16),
          _buildTeamStatusCard(theme),
          const SizedBox(height: 24),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  PracticeSession _createSampleSession() {
    return PracticeSession(
      title: 'High Press & Transition Recovery',
      date: DateTime(2026, 7, 28, 18),
      location: 'Griffith High School',
      notes: 'Emphasize communication, compactness, and immediate reactions.',
      blocks: const [
        PracticeBlock(
          title: 'Dynamic Warm-Up + Rondo',
          category: 'Activation',
          durationMinutes: 12,
          description:
              'Prepare the players physically and mentally before introducing '
              'the main tactical theme. Begin with dynamic movement before '
              'moving directly into a high-tempo possession rondo.',
          coachingPoints: [
            'Increase movement intensity gradually.',
            'Use an open body shape when receiving.',
            'Communicate before the ball arrives.',
            'React immediately after losing possession.',
          ],
          equipment: [
            'Soccer balls',
            'Cones',
            'Pinnies',
          ],
        ),
        PracticeBlock(
          title: 'Passing Patterns',
          category: 'Technical Development',
          durationMinutes: 15,
          description:
              'Develop clean passing, supporting movement, and forward-facing '
              'receiving actions that prepare the team to play through pressure.',
          coachingPoints: [
            'Pass with appropriate pace.',
            'Move immediately after releasing the ball.',
            'Check the shoulder before receiving.',
            'Receive across the body whenever possible.',
          ],
          equipment: [
            'Soccer balls',
            'Cones',
          ],
        ),
        PracticeBlock(
          title: 'High-Press Trigger Game',
          category: 'Tactical Development',
          durationMinutes: 25,
          description:
              'Train the front line and midfield to recognize pressing triggers, '
              'close space together, and prevent the opponent from playing out.',
          coachingPoints: [
            'The first defender sets the direction of the press.',
            'Supporting players close nearby passing lanes.',
            'Keep the team compact behind the press.',
            'Attack immediately after regaining possession.',
          ],
          equipment: [
            'Soccer balls',
            'Cones',
            'Pinnies',
            'Goals',
          ],
        ),
        PracticeBlock(
          title: 'Conditioned Match',
          category: 'Competitive Application',
          durationMinutes: 30,
          description:
              'Apply the session theme in a realistic match environment with '
              'bonus rewards for regaining possession in advanced areas.',
          coachingPoints: [
            'Recognize when to press and when to recover.',
            'Communicate between all three lines.',
            'Transition forward quickly after a regain.',
            'Maintain team shape when the press is broken.',
          ],
          equipment: [
            'Soccer balls',
            'Pinnies',
            'Goals',
          ],
        ),
        PracticeBlock(
          title: 'Recovery + Panther Reflection',
          category: 'Cooldown',
          durationMinutes: 8,
          description:
              'Lower the players’ heart rates, restore mobility, and finish with '
              'a brief team reflection on the session objectives.',
          coachingPoints: [
            'Use controlled breathing during recovery.',
            'Complete each mobility movement deliberately.',
            'Identify one thing the team performed well.',
            'Identify one thing the team must improve.',
          ],
          equipment: [
            'Soccer balls',
          ],
        ),
      ],
    );
  }

  Widget _buildSessionHeader({
    required ThemeData theme,
    required PracticeSession session,
  }) {
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
            session.title,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            '${_formatDate(session.date)} • '
            '${_formatTime(session.date)} • '
            '${session.totalDurationMinutes} Minutes',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (session.location.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              session.location,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentBlockCard({
    required ThemeData theme,
    required PracticeBlock block,
  }) {
    return _DashboardCard(
      eyebrow: 'CURRENT BLOCK',
      icon: Icons.play_circle_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            block.category,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            block.title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            block.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          _InformationRow(
            icon: Icons.schedule,
            label: 'Block Duration',
            value: '${block.durationMinutes} Minutes',
          ),
          const SizedBox(height: 12),
          _InformationRow(
            icon: Icons.timer_outlined,
            label: 'Time Remaining',
            value: _formatDuration(block.durationMinutes),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                debugPrint('Start Block pressed: ${block.title}');
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('START BLOCK'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextBlockCard({
    required ThemeData theme,
    required PracticeBlock block,
  }) {
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
                  block.title,
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  block.category,
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
              '${block.durationMinutes} MIN',
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

  Widget _buildSessionOverviewCard({
    required ThemeData theme,
    required PracticeSession session,
  }) {
    return _DashboardCard(
      eyebrow: 'SESSION OVERVIEW',
      icon: Icons.assignment_outlined,
      child: Column(
        children: [
          _InformationRow(
            icon: Icons.view_agenda_outlined,
            label: 'Training Blocks',
            value: '${session.blockCount}',
          ),
          const SizedBox(height: 14),
          _InformationRow(
            icon: Icons.schedule_outlined,
            label: 'Total Duration',
            value: '${session.totalDurationMinutes} Minutes',
          ),
          const SizedBox(height: 14),
          _InformationRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: session.location.isEmpty ? 'Not Set' : session.location,
          ),
          if (session.notes.isNotEmpty) ...[
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'SESSION NOTES',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                session.notes,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ),
          ],
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

  String _formatDate(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${weekdays[date.weekday - 1]}, '
        '${months[date.month - 1]} ${date.day}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  String _formatDuration(int durationMinutes) {
    final minutes = durationMinutes.toString().padLeft(2, '0');
    return '$minutes:00';
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
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}