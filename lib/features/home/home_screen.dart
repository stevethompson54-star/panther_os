import 'package:flutter/material.dart';

import '../../shared/widgets/mission_status_badge.dart';
import '../../shared/widgets/primary_action_button.dart';
import '../../shared/widgets/status_tile.dart';
import 'widgets/mission_control_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.45,
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.shield_outlined,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PANTHEROS',
                            style: theme.textTheme.titleLarge?.copyWith(
                              letterSpacing: 1.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'PREPARE • DECIDE • COACH',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Text(
                    'MISSION CONTROL',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Good Morning, Coach',
                    style: theme.textTheme.headlineLarge,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Tuesday • July 21',
                    style: theme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 28),

                  MissionControlCard(
                    icon: Icons.sports_soccer,
                    title: "Today's Training",
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final useTwoColumns = constraints.maxWidth >= 650;

                        final trainingDetails = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MissionStatusBadge(
                              status: MissionStatus.attentionRequired,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'High Press & Transition Recovery',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 18,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '6:00 PM',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Preparation is nearly complete.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        );

                        final readinessChecklist = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Readiness Checklist',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 14),
                            const StatusTile(
                              label: 'Session Generated',
                              status: StatusType.success,
                            ),
                            const SizedBox(height: 10),
                            const StatusTile(
                              label: 'Equipment Ready',
                              status: StatusType.success,
                            ),
                            const SizedBox(height: 10),
                            const StatusTile(
                              label: '2 Players Unconfirmed',
                              status: StatusType.warning,
                            ),
                          ],
                        );

                        if (useTwoColumns) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: trainingDetails),
                              const SizedBox(width: 32),
                              Container(
                                width: 1,
                                height: 170,
                                color: theme.colorScheme.outlineVariant,
                              ),
                              const SizedBox(width: 32),
                              Expanded(child: readinessChecklist),
                            ],
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            trainingDetails,
                            const SizedBox(height: 24),
                            Divider(
                              color: theme.colorScheme.outlineVariant,
                            ),
                            const SizedBox(height: 20),
                            readinessChecklist,
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final useTwoColumns = constraints.maxWidth >= 600;

                      final attendanceCard = MissionControlCard(
                        icon: Icons.groups,
                        title: 'Attendance',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '13 Expected',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '11 Confirmed',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );

                      final weatherCard = MissionControlCard(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Weather',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '76°F',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ideal training conditions',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      );

                      if (useTwoColumns) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: attendanceCard),
                            const SizedBox(width: 16),
                            Expanded(child: weatherCard),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          attendanceCard,
                          const SizedBox(height: 16),
                          weatherCard,
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                 PrimaryActionButton(
  label: 'Begin Practice',
  icon: Icons.play_arrow,
  onPressed: () {
    debugPrint('Begin Practice pressed');
    Navigator.of(context).pushNamed('/practice');
  },
),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}