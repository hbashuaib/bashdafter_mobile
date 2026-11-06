import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),

      body: SingleChildScrollView(
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(20),

            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(Icons.store, size: 80, color: AppTheme.primaryBlue),
                  const SizedBox(height: 20),

                  Text(
                    'BashDafter',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Version 1.0.0',

                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Card(
                    color: Theme.of(context).colorScheme.primary
                        .withValues(alpha: 0.05),
                    child: const Padding(
                      padding: EdgeInsets.all(12),

                      child: Text(
                        'BashDafter helps businesses manage customers, purchases, payments, inventory, and reports.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Business accounting and inventory management system.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Developed by BashSoft Digital',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '© 2026 BashSoft Digital',
                    style: TextStyle(color: Colors.grey),
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
