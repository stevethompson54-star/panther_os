import 'package:flutter/material.dart';

import '../../design_system/panther_scaffold.dart';
import 'controllers/practice_controller.dart';
import 'models/practice_block.dart';
import 'models/practice_session.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late final PracticeController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PracticeController(
      session: _createSampleSession(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
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
              _buildSessionHeader(
                theme: theme,
                controller: _controller,
              ),
              const SizedBox(height: 20),
              _buildProgressCard(
                theme: theme,
                controller: _controller,
              ),
              const SizedBox(height: 16),
              if (_controller.isPracticeComplete)
                _buildPracticeCompleteCard(
                  theme: theme,
                  controller: _controller,
                )
              else if (_controller.currentBlock != null)
                _buildCurrentBlockCard(
                  theme: theme,
                  controller: _controller,
                  block: _controller.currentBlock!,
                ),
              if (!_controller.isPracticeComplete &&
                  _controller.nextBlock != null) ...[
                const SizedBox(height: 16),
                _buildNextBlockCard(
                  theme: theme,
                  block: _controller.nextBlock!,
                ),
              ],
              const SizedBox(height: 16),
              _buildSessionOverviewCard(
                theme: theme,
                session: _controller.session,
              ),
              const SizedBox(height: 16),
              _buildTeamStatusCard(theme),
              const SizedBox(height: 24),
              _buildActionButtons(
                context: context,
                controller: _controller,
              ),
            ],
          ),
        );
      },
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
    required PracticeController controller,
  }) {
    final session = controller.session;

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
          _buildStatusBadge(controller),
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

  Widget _buildStatusBadge(PracticeController controller) {
    late final String label;
    late final Color color;
    late final IconData icon;

    if (controller.isPracticeComplete) {
      label = 'COMPLETE';
      color = Colors.blue;
      icon = Icons.check_circle;
    } else if (controller.isPracticePaused) {
      label = 'PAUSED';
      color = Colors.orange;
      icon = Icons.pause_circle;
    } else if (controller.isPracticeStarted) {
      label = 'LIVE';
      color = Colors.green;
      icon = Icons.circle;
    } else {
      label = 'READY';
      color = Colors.grey;
      icon = Icons.radio_button_checked;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard({
    required ThemeData theme,
    required PracticeController controller,
  }) {
    final totalBlocks = controller.session.blockCount;
    final displayedBlockNumber = controller.isPracticeComplete
        ? totalBlocks
        : controller.currentBlockIndex + 1;

    return _DashboardCard(
      eyebrow: 'PRACTICE PROGRESS',
      icon: Icons.trending_up,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  controller.isPracticeComplete
                      ? 'All blocks completed'
                      : 'Block $displayedBlockNumber of $totalBlocks',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                '${(controller.progress * 100).round()}%',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: controller.progress,
            minHeight: 10,
            borderRadius: BorderRadius.circular(999),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${controller.completedBlockCount} completed',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                '${controller.remainingBlockCount} remaining',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBlockCard({
    required ThemeData theme,
    required PracticeController controller,
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
              onPressed: controller.isPracticeStarted
                  ? null
                  : controller.startPractice,
              icon: const Icon(Icons.play_arrow),
              label: Text(
                controller.isPracticeStarted
                    ? 'BLOCK ACTIVE'
                    : 'START PRACTICE',
              ),
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

  Widget _buildPracticeCompleteCard({
    required ThemeData theme,
    required PracticeController controller,
  }) {
    return _DashboardCard(
      eyebrow: 'PRACTICE COMPLETE',
      icon: Icons.emoji_events_outlined,
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Training Session Completed',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${controller.session.blockCount} blocks completed across '
            '${controller.session.totalDurationMinutes} planned minutes.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: controller.restartPractice,
              icon: const Icon(Icons.restart_alt),
              label: const Text('RESTART PRACTICE'),
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

  Widget _buildActionButtons({
    required BuildContext context,
    required PracticeController controller,
  }) {
    if (controller.isPracticeComplete) {
      return TextButton.icon(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back),
        label: const Text('RETURN TO MISSION CONTROL'),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: controller.isPracticeStarted
                ? controller.moveToNextBlock
                : null,
            icon: Icon(
              controller.nextBlock == null
                  ? Icons.check
                  : Icons.skip_next,
            ),
            label: Text(
              controller.nextBlock == null
                  ? 'COMPLETE PRACTICE'
                  : 'NEXT BLOCK',
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: controller.isPracticeStarted
                ? controller.togglePause
                : null,
            icon: Icon(
              controller.isPracticePaused
                  ? Icons.play_arrow
                  : Icons.pause,
            ),
            label: Text(
              controller.isPracticePaused
                  ? 'RESUME PRACTICE'
                  : 'PAUSE PRACTICE',
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: controller.isPracticeStarted
                ? controller.completePractice
                : null,
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