import 'package:flutter/material.dart';

import '../services/dashboard_service.dart';
import '../../customers/screens/customers_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? dashboardData;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final data = await DashboardService().getDashboard();

    setState(() {
      dashboardData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: dashboardData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: ListTile(
                      title: const Text('Customers'),
                      trailing: Text(dashboardData!['customers'].toString()),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      title: const Text('Total Purchases'),
                      trailing: Text(
                        dashboardData!['total_purchases'].toString(),
                      ),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      title: const Text('Total Payments'),
                      trailing: Text(
                        dashboardData!['total_payments'].toString(),
                      ),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      title: const Text('Balance'),
                      trailing: Text(
                        dashboardData!['total_balance'].toString(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => const CustomersScreen(),
                        ),
                      );
                    },

                    child: const Text('Customers'),
                  ),
                ],
              ),
            ),
    );
  }
}
