import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          const Center(
            child: CircleAvatar(
              radius: 45,
              child: Icon(Icons.person, size: 50),
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User'),
              subtitle: const Text('Hussein Bashuaib'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Application'),
              subtitle: const Text('BashDafter'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('Role'),
              subtitle: const Text('Owner'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Theme'),
              subtitle: Text(isDarkMode ? 'Dark Mode' : 'Light Mode'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Version'),
              subtitle: const Text('1.0.0'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.business),
              title: const Text('Company'),
              subtitle: const Text('BashSoft Digital'),
            ),
          ),
        ],
      ),
    );
  }
}
