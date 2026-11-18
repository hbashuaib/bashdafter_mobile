import 'package:flutter/material.dart';

import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/customers/screens/customers_screen.dart';
import '../../features/reports/screens/reports_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/products/screens/products_screen.dart';
import '../../features/auth/models/user_profile.dart';
import '../storage/token_storage.dart';
import '../localization/localization_extension.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;
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

    final pages = <Widget>[
      const DashboardScreen(),
      const CustomersScreen(),
      const ProductsScreen(),
    ];

    if (profile!.isOwner || profile!.isAdmin || profile!.isManager) {
      pages.add(const ReportsScreen());
    }

    pages.add(const SettingsScreen());

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),

      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showUnselectedLabels: true,
        enableFeedback: true,
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: context.l10n.dashboard,
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: context.l10n.customers,
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.inventory_2),
            label: context.l10n.products,
          ),

          if (profile!.isOwner || profile!.isAdmin || profile!.isManager)
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart),
              label: context.l10n.reports,
            ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: context.l10n.settings,
          ),
        ],
      ),
    );
  }
}
