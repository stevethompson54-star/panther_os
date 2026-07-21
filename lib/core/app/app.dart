import 'package:flutter/material.dart';

class PantherApp extends StatelessWidget {
  const PantherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PantherOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const PantherHomePage(),
    );
  }
}

class PantherHomePage extends StatelessWidget {
  const PantherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐾 PantherOS'),
      ),
      body: const Center(
        child: Text(
          'Welcome, Coach.',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}