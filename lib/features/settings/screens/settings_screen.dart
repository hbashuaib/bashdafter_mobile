import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/storage/token_storage.dart';
import '../../auth/screens/login_screen.dart';
import '../../../core/theme/theme_provider.dart';
import '../../auth/models/user_profile.dart';
import '../../users/screens/users_screen.dart';
import '../../products/screens/categories_screen.dart';
import '../../products/screens/units_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';

import 'about_screen.dart';
import 'profile_screen.dart';
import 'shop_profile_screen.dart';
import 'language_screen.dart';

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
      return Scaffold(body: Center(child: Text(context.l10n.profileNotFound)));
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings)),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
        children: [
          if (profile!.isOwner || profile!.isAdmin)
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.manage_accounts,
                  color: Colors.orange,
                ),
                title: Text(context.l10n.userManagement),
                subtitle: Text(context.l10n.manageSystemUsers),
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

                title: Text(context.l10n.productCategories),

                subtitle: Text(context.l10n.manageProductCategories),

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

                title: Text(context.l10n.productUnits),

                subtitle: Text(context.l10n.manageProductUnits),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UnitsScreen()),
                  );
                },
              ),
            ),

          Card(
            color: AppColors.cardTint(context, Colors.blue.shade50),

            child: Padding(
              padding: EdgeInsets.all(16),

              child: Column(
                children: [
                  Text(
                    context.l10n.settings,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 6),

                  Text(
                    context.l10n.manageApplicationPreferences,
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
              title: Text(context.l10n.shopProfile),
              subtitle: Text(context.l10n.manageShopInformation),

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
              title: Text(context.l10n.profile),
              subtitle: Text(context.l10n.userAndApplicationDetails),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.indigo),
              trailing: const Icon(Icons.arrow_forward_ios),
              title: Text(context.l10n.language),
              subtitle: Text(context.l10n.changeApplicationLanguage),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LanguageScreen()),
                );
              },
            ),
          ),

          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Card(
                child: SwitchListTile(
                  secondary: const Icon(Icons.dark_mode, color: Colors.purple),
                  title: Text(context.l10n.darkMode),
                  value: themeProvider.themeMode == ThemeMode.dark,
                  subtitle: Text(
                    themeProvider.themeMode == ThemeMode.dark
                        ? context.l10n.darkModeEnabled
                        : context.l10n.lightModeEnabled,
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
              title: Text(context.l10n.about),
              subtitle: Text(context.l10n.applicationInformation),

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
              title: Text(context.l10n.logout),
              subtitle: Text(context.l10n.signOut),

              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,

                  builder: (dialogContext) {
                    return AlertDialog(
                      title: Text(context.l10n.logout),

                      content: Text(context.l10n.areYouSureLogout),

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
        ],
      ),
    );
  }
}
