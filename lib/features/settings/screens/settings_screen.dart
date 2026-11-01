import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/storage/token_storage.dart';
import '../../auth/screens/login_screen.dart';
import '../../../core/theme/theme_provider.dart';

import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),

      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),

            title: const Text('Profile'),
          ),

          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                value: themeProvider.themeMode == ThemeMode.dark,

                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.info),

            title: const Text('About'),

            onTap: () {
              Navigator.push(
                context,

                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),

            title: const Text('Logout'),

            onTap: () async {
              await TokenStorage.clear();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,

                MaterialPageRoute(builder: (_) => const LoginScreen()),

                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
