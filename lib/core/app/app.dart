import 'package:flutter/material.dart';

import '../../features/home/home_screen.dart';
import '../theme/panther_theme.dart';

class PantherApp extends StatelessWidget {
  const PantherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PantherOS',
      debugShowCheckedModeBanner: false,
      theme: PantherTheme.dark,
      home: const HomeScreen(),
    );
  }
}