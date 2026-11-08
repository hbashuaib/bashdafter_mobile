import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/dashboard_service.dart';
import '../../../core/storage/token_storage.dart';
import '../../auth/screens/login_screen.dart';
import '../../inventory/screens/inventory_menu_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final currencyFormatter = NumberFormat('#,##0.00');
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await DashboardService().getDashboard();      

      if (!mounted) return;

      setState(() {
        dashboardData = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load dashboard')));

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () async {
              final navigator = Navigator.of(context);
              await TokenStorage.clear();

              if (!mounted) return;

              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardData == null
          ? const Center(child: Text('No dashboard data available'))
          : RefreshIndicator(
              onRefresh: loadDashboard,

              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),

                padding: const EdgeInsets.all(20),

                children: [
                  Card(
                    color: Colors.blue.shade50,
                    child: ListTile(
                      leading: const Icon(Icons.people, color: Colors.blue),
                      title: const Text('Customers'),
                      trailing: Text(
                        dashboardData!['customers'].toString(),

                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Card(
                    color: Colors.orange.shade50,
                    child: ListTile(
                      leading: const Icon(
                        Icons.shopping_cart,
                        color: Colors.orange,
                      ),
                      title: const Text('Total Purchases'),
                      trailing: Text(
                        'YER ${currencyFormatter.format(double.tryParse(dashboardData!['total_purchases'].toString()) ?? 0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Card(
                    color: Colors.green.shade50,
                    child: ListTile(
                      leading: const Icon(Icons.payments, color: Colors.green),
                      title: const Text('Total Payments'),
                      trailing: Text(
                        'YER ${currencyFormatter.format(double.tryParse(dashboardData!['total_payments'].toString()) ?? 0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Card(
                    color: Colors.purple.shade50,
                    child: ListTile(
                      leading: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.purple,
                      ),
                      title: const Text('Balance'),
                      trailing: Text(
                        'YER ${currencyFormatter.format(double.tryParse(dashboardData!['total_balance'].toString()) ?? 0)}',

                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              (double.tryParse(
                                        dashboardData!['total_balance']
                                            .toString(),
                                      ) ??
                                      0) >
                                  0
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.inventory, color: Colors.blue),
                      title: const Text('Inventory'),

                      subtitle: const Text(
                        'Stock adjustments and inventory history',
                      ),

                      trailing: const Icon(Icons.arrow_forward_ios),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InventoryMenuScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}
