import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),

      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(Icons.store, size: 80),

            SizedBox(height: 20),

            Text(
              'BashDafter',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Text('Version 1.0.0'),

            SizedBox(height: 20),

            Text('Developed by BashSoft Digital'),

            SizedBox(height: 10),

            Text('© 2026'),
          ],
        ),
      ),
    );
  }
}
