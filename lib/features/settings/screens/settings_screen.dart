import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/storage/token_storage.dart';
import '../../auth/screens/login_screen.dart';
import '../../../core/theme/theme_provider.dart';

import 'about_screen.dart';
import 'profile_screen.dart';
import 'shop_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            color: Colors.blue.shade50,

            child: const Padding(
              padding: EdgeInsets.all(16),

              child: Column(
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 6),

                  Text(
                    'Manage application preferences and information',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.store, color: Colors.blue),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: const Text('Shop Profile'),
              subtitle: const Text('Manage shop information'),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShopProfileScreen()),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.green),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: const Text('Profile'),
              subtitle: const Text('User and application details'),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
          ),

          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.dark_mode, color: Colors.purple),
                  title: const Text('Dark Mode'),
                  value: themeProvider.themeMode == ThemeMode.dark,
                  subtitle: Text(
                    themeProvider.themeMode == ThemeMode.dark
                        ? 'Dark mode enabled'
                        : 'Light mode enabled',
                  ),

                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              );
            },
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.info, color: Colors.teal),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: const Text('About'),
              subtitle: const Text('Application information'),

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              },
            ),
          ),
          
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              subtitle: const Text('Sign out of the application'),

              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,

                  builder: (dialogContext) {
                    return AlertDialog(
                      title: const Text('Logout'),

                      content: const Text('Are you sure you want to logout?'),

                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, false);
                          },

                          child: const Text('Cancel'),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext, true);
                          },

                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  },
                );

                if (confirmed != true) return;

                await TokenStorage.clear();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
