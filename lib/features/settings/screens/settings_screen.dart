import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/storage/token_storage.dart';
import '../../auth/screens/login_screen.dart';
import '../../../core/theme/theme_provider.dart';
import '../../auth/models/user_profile.dart';
import '../../users/screens/users_screen.dart';
import '../../products/screens/categories_screen.dart';
import '../../products/screens/units_screen.dart';

import 'about_screen.dart';
import 'profile_screen.dart';
import 'shop_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserProfile? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final storedProfile = await TokenStorage.getProfile();

    if (!mounted) return;

    setState(() {
      profile = storedProfile;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (profile == null) {
      return const Scaffold(body: Center(child: Text('Profile not found')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (profile!.isOwner || profile!.isAdmin)
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.manage_accounts,
                  color: Colors.orange,
                ),
                title: const Text('User Management'),
                subtitle: const Text('Manage system users'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UsersScreen()),
                  );
                },
              ),
            ),

          if (profile!.isOwner || profile!.isAdmin)
            Card(
              child: ListTile(
                leading: const Icon(Icons.category, color: Colors.purple),
                trailing: const Icon(Icons.arrow_forward_ios),

                title: const Text('Product Categories'),

                subtitle: const Text('Manage product categories'),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoriesScreen()),
                  );
                },
              ),
            ),

          if (profile!.isOwner || profile!.isAdmin)
            Card(
              child: ListTile(
                leading: const Icon(Icons.straighten, color: Colors.teal),
                trailing: const Icon(Icons.arrow_forward_ios),

                title: const Text('Product Units'),

                subtitle: const Text('Manage product units'),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UnitsScreen()),
                  );
                },
              ),
            ),

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
