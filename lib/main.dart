import 'package:flutter/material.dart';

void main() {
  runApp(const PantherApp());
}

class PantherApp extends StatelessWidget {
  const PantherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PantherOS',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
      ),
      home: const PantherHome(),
    );
  }
}

class PantherHome extends StatelessWidget {
  const PantherHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🐾 PantherOS'),
        centerTitle: true,
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