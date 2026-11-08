import 'package:flutter/material.dart';

import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/customers/screens/customers_screen.dart';
import '../../features/reports/screens/reports_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/products/screens/products_screen.dart';
import '../../features/auth/models/user_profile.dart';
import '../storage/token_storage.dart';

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
      return const Scaffold(body: Center(child: Text('Profile not found')));
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
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Customers',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Products',
          ),

          if (profile!.isOwner || profile!.isAdmin || profile!.isManager)
            const BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Reports',
            ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
