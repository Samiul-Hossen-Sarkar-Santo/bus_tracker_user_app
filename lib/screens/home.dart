import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        centerTitle: true,
        title: const Text(
          'Home Screen',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey[100],
        child: Center(
          child: Text(
            'Welcome to the Home Screen!',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.green[900],
            ),
          ),
        ),
      ),
    );
  }
}
