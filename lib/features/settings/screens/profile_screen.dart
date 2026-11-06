import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),

        children: [
          Card(
            color: Colors.blue.shade50,

            child: const Padding(
              padding: EdgeInsets.all(16),

              child: Column(
                children: [
                  Text(
                    'Profile Information',

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 6),

                  Text('Application and user details'),
                ],
              ),
            ),
          ),

          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primary,

              child: const Icon(Icons.person, size: 55, color: Colors.white),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Hussein Bashuaib',
            textAlign: TextAlign.center,

            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            'Owner',
            textAlign: TextAlign.center,

            style: TextStyle(color: Colors.grey.shade600),
          ),

          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('User'),
              subtitle: const Text('Hussein Bashuaib'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.store, color: Colors.green),
              title: const Text('Application'),
              subtitle: const Text('BashDafter'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.verified_user, color: Colors.orange),
              title: const Text('Role'),
              subtitle: const Text('Owner'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.color_lens, color: Colors.purple),
              title: const Text('Theme'),
              subtitle: Text(isDarkMode ? 'Dark Mode' : 'Light Mode'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.info, color: Colors.teal),
              title: const Text('Version'),
              subtitle: const Text('1.0.0'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.business, color: Colors.indigo),
              title: const Text('Company'),
              subtitle: const Text('BashSoft Digital'),
            ),
          ),
        ],
      ),
    );
  }
}
