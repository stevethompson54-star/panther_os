import 'package:flutter/material.dart';

import '../../design_system/panther_scaffold.dart';
import 'coach_mode_screen.dart';
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
    _controller = PracticeController(session: _createSampleSession());
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
          subtitle: 'Run today’s session from one focused coaching workspace.',
          showBackButton: true,
          maxContentWidth: 960,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCompactSessionHeader(theme, _controller),
              const SizedBox(height: 16),
              _buildDualProgressCard(theme, _controller),
              const SizedBox(height: 16),
              if (_controller.isPracticeComplete)
                _buildPracticeCompleteCard(theme, _controller)
              else if (_controller.currentBlock != null)
                _buildCurrentBlockMissionControl(
                  theme,
                  _controller,
                  _controller.currentBlock!,
                ),
              if (!_controller.isPracticeComplete &&
                  _controller.nextBlock != null) ...[
                const SizedBox(height: 16),
                _buildNextBlockCard(theme, _controller.nextBlock!),
              ],
              const SizedBox(height: 16),
              _buildSessionOverviewCard(theme, _controller.session),
              const SizedBox(height: 16),
              _buildTeamStatusCard(theme),
              const SizedBox(height: 22),
              _buildActionButtons(context, _controller),
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
              'Prepare the players physically and mentally before introducing the main tactical theme. Begin with dynamic movement before moving directly into a high-tempo possession rondo.',
          coachingPoints: [
            'Increase movement intensity gradually.',
            'Use an open body shape when receiving.',
            'Communicate before the ball arrives.',
            'React immediately after losing possession.',
          ],
          equipment: ['Soccer balls', 'Cones', 'Pinnies'],
        ),
        PracticeBlock(
          title: 'Passing Patterns',
          category: 'Technical Development',
          durationMinutes: 15,
          description:
              'Develop clean passing, supporting movement, and forward-facing receiving actions that prepare the team to play through pressure.',
          coachingPoints: [
            'Pass with appropriate pace.',
            'Move immediately after releasing the ball.',
            'Check the shoulder before receiving.',
            'Receive across the body whenever possible.',
          ],
          equipment: ['Soccer balls', 'Cones'],
        ),
        PracticeBlock(
          title: 'High-Press Trigger Game',
          category: 'Tactical Development',
          durationMinutes: 25,
          description:
              'Train the front line and midfield to recognize pressing triggers, close space together, and prevent the opponent from playing out.',
          coachingPoints: [
            'The first defender sets the direction of the press.',
            'Supporting players close nearby passing lanes.',
            'Keep the team compact behind the press.',
            'Attack immediately after regaining possession.',
          ],
          equipment: ['Soccer balls', 'Cones', 'Pinnies', 'Goals'],
        ),
        PracticeBlock(
          title: 'Conditioned Match',
          category: 'Competitive Application',
          durationMinutes: 30,
          description:
              'Apply the session theme in a realistic match environment with bonus rewards for regaining possession in advanced areas.',
          coachingPoints: [
            'Recognize when to press and when to recover.',
            'Communicate between all three lines.',
            'Transition forward quickly after a regain.',
            'Maintain team shape when the press is broken.',
          ],
          equipment: ['Soccer balls', 'Pinnies', 'Goals'],
        ),
        PracticeBlock(
          title: 'Recovery + Panther Reflection',
          category: 'Cooldown',
          durationMinutes: 8,
          description:
              'Lower the players’ heart rates, restore mobility, and finish with a brief team reflection on the session objectives.',
          coachingPoints: [
            'Use controlled breathing during recovery.',
            'Complete each mobility movement deliberately.',
            'Identify one thing the team performed well.',
            'Identify one thing the team must improve.',
          ],
          equipment: ['Soccer balls'],
        ),
      ],
    );
  }

  Widget _buildCompactSessionHeader(
    ThemeData theme,
    PracticeController controller,
  ) {
    final session = controller.session;

    return _Panel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 680;

          final sessionInfo = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusBadge(controller),
              const SizedBox(height: 12),
              Text(
                session.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${_formatDate(session.date)} • ${_formatTime(session.date)} • ${session.totalDurationMinutes} Minutes',
                style: theme.textTheme.bodyMedium,
              ),
              if (session.location.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        session.location,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );

          final timer = Column(
            crossAxisAlignment:
                wide ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                _formatClock(controller.sessionElapsed),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'SESSION TIMER',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          );

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: sessionInfo),
                const SizedBox(width: 28),
                timer,
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sessionInfo,
              const SizedBox(height: 18),
              timer,
            ],
          );
        },
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDualProgressCard(
    ThemeData theme,
    PracticeController controller,
  ) {
    final totalBlocks = controller.session.blockCount;
    final displayedBlockNumber = controller.isPracticeComplete
        ? totalBlocks
        : controller.currentBlockIndex + 1;

    return _DashboardCard(
      eyebrow: 'SESSION CONTROL',
      icon: Icons.monitor_heart_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgressSection(
            label: 'Overall Practice',
            supportingText: controller.isPracticeComplete
                ? 'All blocks completed'
                : 'Block $displayedBlockNumber of $totalBlocks',
            value: controller.progress,
            valueLabel: '${(controller.progress * 100).round()}%',
            color: theme.colorScheme.primary,
          ),
          if (!controller.isPracticeComplete &&
              controller.currentBlock != null) ...[
            const SizedBox(height: 22),
            _ProgressSection(
              label: 'Current Block',
              supportingText: controller.currentBlock!.title,
              value: controller.currentBlockProgress,
              valueLabel:
                  '${(controller.currentBlockProgress * 100).round()}%',
              color: Colors.green,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentBlockMissionControl(
    ThemeData theme,
    PracticeController controller,
    PracticeBlock block,
  ) {
    final remaining = controller.blockTimeRemaining;
    final isLowTime = controller.isPracticeStarted &&
        !controller.isPracticePaused &&
        remaining.inSeconds > 0 &&
        remaining.inSeconds <= 120;
    final countdownColor =
        isLowTime ? theme.colorScheme.error : theme.colorScheme.onSurface;

    return _DashboardCard(
      eyebrow: 'CURRENT BLOCK',
      icon: Icons.sports_soccer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 680;

              final details = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    block.category.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    block.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    block.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                ],
              );

              final timer = Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: isLowTime
                      ? theme.colorScheme.error.withValues(alpha: 0.10)
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isLowTime
                        ? theme.colorScheme.error.withValues(alpha: 0.35)
                        : theme.colorScheme.outlineVariant,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      wide ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatCountdown(remaining),
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: countdownColor,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'TIME REMAINING',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isLowTime
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${block.durationMinutes} minute block',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: details),
                    const SizedBox(width: 24),
                    timer,
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [details, const SizedBox(height: 18), timer],
              );
            },
          ),
          const SizedBox(height: 22),
          _CoachFocusPanel(coachingPoints: block.coachingPoints),
          const SizedBox(height: 20),
          Text(
            'EQUIPMENT',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 1,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: block.equipment
                .map(
                  (item) => _EquipmentChip(
                    label: item,
                    icon: _equipmentIcon(item),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  _timerStatusIcon(controller),
                  size: 19,
                  color: isLowTime
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _blockTimerMessage(controller),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isLowTime
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: isLowTime ? FontWeight.w700 : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _openCoachMode(context),
              icon: Icon(
                controller.isPracticeStarted
                    ? Icons.fullscreen
                    : Icons.play_arrow,
              ),
              label: Text(
                controller.isPracticeStarted
                    ? 'RETURN TO COACH MODE'
                    : 'BEGIN PRACTICE',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCoachMode(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => CoachModeScreen(
          controller: _controller,
        ),
      ),
    );
  }

  Widget _buildNextBlockCard(ThemeData theme, PracticeBlock block) {
    return _DashboardCard(
      eyebrow: 'NEXT BLOCK',
      icon: Icons.skip_next_outlined,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                block.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                block.category,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );
          final duration = Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [details, const SizedBox(height: 14), duration],
            );
          }

          return Row(
            children: [
              Expanded(child: details),
              const SizedBox(width: 20),
              duration,
            ],
          );
        },
      ),
    );
  }

  Widget _buildPracticeCompleteCard(
    ThemeData theme,
    PracticeController controller,
  ) {
    return _DashboardCard(
      eyebrow: 'PRACTICE COMPLETE',
      icon: Icons.emoji_events_outlined,
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withValues(alpha: 0.14),
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Training Session Completed',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${controller.session.blockCount} blocks completed in ${_formatClock(controller.sessionElapsed)}.',
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

  Widget _buildSessionOverviewCard(
    ThemeData theme,
    PracticeSession session,
  ) {
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

  Widget _buildActionButtons(
    BuildContext context,
    PracticeController controller,
  ) {
    if (controller.isPracticeComplete) {
      return Center(
        child: TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          label: const Text('RETURN TO MISSION CONTROL'),
        ),
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
              controller.nextBlock == null ? Icons.check : Icons.skip_next,
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
              controller.isPracticePaused ? Icons.play_arrow : Icons.pause,
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
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          label: const Text('RETURN TO MISSION CONTROL'),
        ),
      ],
    );
  }

  IconData _equipmentIcon(String item) {
    final normalized = item.toLowerCase();
    if (normalized.contains('ball')) return Icons.sports_soccer;
    if (normalized.contains('cone')) return Icons.change_history;
    if (normalized.contains('goal')) return Icons.sports_outlined;
    if (normalized.contains('pinnie') || normalized.contains('bib')) {
      return Icons.checkroom_outlined;
    }
    return Icons.inventory_2_outlined;
  }

  IconData _timerStatusIcon(PracticeController controller) {
    if (!controller.isPracticeStarted) return Icons.info_outline;
    if (controller.isPracticePaused) return Icons.pause_circle_outline;
    if (controller.blockTimeRemaining.inSeconds <= 0) {
      return Icons.alarm_on_outlined;
    }
    return Icons.timer_outlined;
  }

  String _blockTimerMessage(PracticeController controller) {
    if (!controller.isPracticeStarted) {
      return 'The block timer will begin when practice starts.';
    }
    if (controller.isPracticePaused) {
      return 'Timer paused. Resume when the team is ready.';
    }
    if (controller.blockTimeRemaining.inSeconds <= 0) {
      return 'Block time has expired. Advance when ready.';
    }
    if (controller.blockTimeRemaining.inSeconds <= 120) {
      return 'Less than two minutes remain in this block.';
    }
    return 'Block timer is running.';
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
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _formatClock(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String _formatCountdown(Duration duration) {
    final safeDuration = duration.isNegative ? Duration.zero : duration;
    final hours = safeDuration.inHours;
    final minutes =
        safeDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        safeDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    final totalMinutes = safeDuration.inMinutes.toString().padLeft(2, '0');
    return '$totalMinutes:$seconds';
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
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
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
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

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.label,
    required this.supportingText,
    required this.value,
    required this.valueLabel,
    required this.color,
  });

  final String label;
  final String supportingText;
  final double value;
  final String valueLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    supportingText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              valueLabel,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: value,
          minHeight: 10,
          borderRadius: BorderRadius.circular(999),
          color: color,
          backgroundColor: color.withValues(alpha: 0.16),
        ),
      ],
    );
  }
}

class _CoachFocusPanel extends StatelessWidget {
  const _CoachFocusPanel({required this.coachingPoints});

  final List<String> coachingPoints;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 9),
              Text(
                'COACHING FOCUS',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...coachingPoints.map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      point,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EquipmentChip extends StatelessWidget {
  const _EquipmentChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 7),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
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
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
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
