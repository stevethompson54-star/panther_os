import 'package:flutter/material.dart';

import '../../features/home/home_screen.dart';
import '../../features/practice/practice_screen.dart';
import '../theme/panther_theme.dart';

class PantherApp extends StatelessWidget {
  const PantherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PantherOS',
      debugShowCheckedModeBanner: false,
      theme: PantherTheme.dark,

      // Initial screen
      initialRoute: '/',

      // App routes
      routes: {
        '/': (context) => const HomeScreen(),
        '/practice': (context) => const PracticeScreen(),
      },
    );
  }
}