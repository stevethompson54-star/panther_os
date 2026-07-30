import 'package:flutter/material.dart';

import 'controllers/practice_controller.dart';

class CoachModeScreen extends StatefulWidget {
  const CoachModeScreen({
    super.key,
    required this.controller,
  });

  final PracticeController controller;

  @override
  State<CoachModeScreen> createState() => _CoachModeScreenState();
}

class _CoachModeScreenState extends State<CoachModeScreen> {
  PracticeController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _controller.beginPractice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final theme = Theme.of(context);
        final currentBlock = _controller.currentBlock;
        final nextBlock = _controller.nextBlock;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _CoachModeHeader(
                    controller: _controller,
                    onExit: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: _controller.isPracticeComplete
                        ? _PracticeCompleteView(
                            controller: _controller,
                            onExit: () => Navigator.of(context).pop(),
                          )
                        : currentBlock == null
                            ? const _EmptyPracticeView()
                            : LayoutBuilder(
                                builder: (context, constraints) {
                                  final compact =
                                      constraints.maxHeight < 720;

                                  return Column(
                                    children: [
                                      _CurrentBlockPanel(
                                        controller: _controller,
                                        compact: compact,
                                      ),
                                      const SizedBox(height: 12),
                                      Expanded(
                                        child: _CoachFocusPanel(
                                          coachingPoints:
                                              currentBlock.coachingPoints,
                                          compact: compact,
                                        ),
                                      ),
                                      if (nextBlock != null) ...[
                                        const SizedBox(height: 12),
                                        _NextBlockStrip(
                                          title: nextBlock.title,
                                          category: nextBlock.category,
                                          durationMinutes:
                                              nextBlock.durationMinutes,
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                  ),
                  if (!_controller.isPracticeComplete) ...[
                    const SizedBox(height: 14),
                    _CoachControls(
                      controller: _controller,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CoachModeHeader extends StatelessWidget {
  const _CoachModeHeader({
    required this.controller,
    required this.onExit,
  });

  final PracticeController controller;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        IconButton(
          tooltip: 'Exit Coach Mode',
          onPressed: onExit,
          icon: const Icon(Icons.close),
        ),
        const SizedBox(width: 6),
        _StatusBadge(controller: controller),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatClock(controller.sessionElapsed),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                fontFeatures: const [
                  FontFeature.tabularFigures(),
                ],
              ),
            ),
            Text(
              'SESSION',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.controller,
  });

  final PracticeController controller;

  @override
  Widget build(BuildContext context) {
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
    } else {
      label = 'LIVE';
      color = Colors.green;
      icon = Icons.circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color: color,
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentBlockPanel extends StatelessWidget {
  const _CurrentBlockPanel({
    required this.controller,
    required this.compact,
  });

  final PracticeController controller;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final block = controller.currentBlock!;
    final remaining = controller.blockTimeRemaining;
    final lowTime = remaining.inSeconds > 0 &&
        remaining.inSeconds <= 120 &&
        !controller.isPracticePaused;

    final timerColor =
        lowTime ? theme.colorScheme.error : theme.colorScheme.onSurface;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 18 : 22),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: lowTime
              ? theme.colorScheme.error.withValues(alpha: 0.45)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Text(
            'CURRENT BLOCK',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 1.3,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: compact ? 8 : 12),
          Text(
            block.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: (compact
                    ? theme.textTheme.headlineSmall
                    : theme.textTheme.headlineMedium)
                ?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            block.category,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: compact ? 12 : 18),
          Text(
            _formatCountdown(remaining),
            style: (compact
                    ? theme.textTheme.displaySmall
                    : theme.textTheme.displayMedium)
                ?.copyWith(
              color: timerColor,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              fontFeatures: const [
                FontFeature.tabularFigures(),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            controller.isPracticePaused
                ? 'TIMER PAUSED'
                : remaining.inSeconds <= 0
                    ? 'BLOCK TIME EXPIRED'
                    : 'TIME REMAINING',
            style: theme.textTheme.labelSmall?.copyWith(
              color: lowTime
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: compact ? 12 : 18),
          LinearProgressIndicator(
            value: controller.currentBlockProgress,
            minHeight: 11,
            borderRadius: BorderRadius.circular(999),
            color: Colors.green,
            backgroundColor: Colors.green.withValues(alpha: 0.16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Block ${controller.currentBlockIndex + 1} '
                'of ${controller.session.blockCount}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                '${(controller.currentBlockProgress * 100).round()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoachFocusPanel extends StatelessWidget {
  const _CoachFocusPanel({
    required this.coachingPoints,
    required this.compact,
  });

  final List<String> coachingPoints;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 16 : 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 9),
              Text(
                'COACH FOCUS',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 12 : 16),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: coachingPoints.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: compact ? 9 : 13),
              itemBuilder: (context, index) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: compact ? 19 : 21,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        coachingPoints[index],
                        style: (compact
                                ? theme.textTheme.bodyMedium
                                : theme.textTheme.titleSmall)
                            ?.copyWith(
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NextBlockStrip extends StatelessWidget {
  const _NextBlockStrip({
    required this.title,
    required this.category,
    required this.durationMinutes,
  });

  final String title;
  final String category;
  final int durationMinutes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.skip_next,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEXT',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$durationMinutes MIN',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoachControls extends StatelessWidget {
  const _CoachControls({
    required this.controller,
  });

  final PracticeController controller;

  @override
  Widget build(BuildContext context) {
    final isFinalBlock = controller.nextBlock == null;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: controller.canMoveToPreviousBlock
                ? controller.moveToPreviousBlock
                : null,
            icon: const Icon(Icons.skip_previous),
            label: const Text('PREVIOUS'),
          ),
        ),
        const SizedBox(width: 10),
        IconButton.filledTonal(
          tooltip: controller.isPracticePaused ? 'Resume' : 'Pause',
          onPressed: controller.togglePause,
          icon: Icon(
            controller.isPracticePaused
                ? Icons.play_arrow
                : Icons.pause,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton.icon(
            onPressed: controller.moveToNextBlock,
            icon: Icon(
              isFinalBlock ? Icons.check : Icons.skip_next,
            ),
            label: Text(
              isFinalBlock ? 'FINISH' : 'NEXT',
            ),
          ),
        ),
      ],
    );
  }
}

class _PracticeCompleteView extends StatelessWidget {
  const _PracticeCompleteView({
    required this.controller,
    required this.onExit,
  });

  final PracticeController controller;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 620),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 70,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 18),
            Text(
              'Practice Complete',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${controller.session.blockCount} blocks completed in '
              '${_formatClock(controller.sessionElapsed)}.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onExit,
                icon: const Icon(Icons.arrow_back),
                label: const Text('RETURN TO PRACTICE OVERVIEW'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyPracticeView extends StatelessWidget {
  const _EmptyPracticeView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Text(
        'No practice blocks are available.',
        style: theme.textTheme.titleMedium,
      ),
    );
  }
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
  final safeDuration =
      duration.isNegative ? Duration.zero : duration;

  final hours = safeDuration.inHours;
  final minutes =
      safeDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds =
      safeDuration.inSeconds.remainder(60).toString().padLeft(2, '0');

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
  }

  final totalMinutes =
      safeDuration.inMinutes.toString().padLeft(2, '0');

  return '$totalMinutes:$seconds';
}
