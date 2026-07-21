import 'package:flutter/material.dart';

import '../../shared/widgets/primary_action_button.dart';
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
                  Text(
                    'Good Morning, Coach',
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tuesday, July 21',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 28),

                  MissionControlCard(
                    icon: Icons.sports_soccer,
                    title: "Today's Training",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'High Press & Transition Recovery',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '6:00 PM',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
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
                              '11 confirmed',
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