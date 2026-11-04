import 'package:flutter/material.dart';

import '../services/inventory_dashboard_service.dart';

class InventoryDashboardScreen extends StatefulWidget {
  const InventoryDashboardScreen({super.key});

  @override
  State<InventoryDashboardScreen> createState() =>
      _InventoryDashboardScreenState();
}

class _InventoryDashboardScreenState extends State<InventoryDashboardScreen> {
  Map<String, dynamic>? dashboard;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final data = await InventoryDashboardService().getDashboard();

    setState(() {
      dashboard = data;
    });
  }

  Widget buildCard({
    required String title,
    required dynamic value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),

        trailing: Text(
          value.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Dashboard')),

      body: dashboard == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadDashboard,

              child: ListView(
                padding: const EdgeInsets.all(20),

                children: [
                  buildCard(
                    title: 'Total Products',
                    value: dashboard!['total_products'],
                    icon: Icons.inventory_2,
                    color: Colors.blue,
                  ),

                  buildCard(
                    title: 'Low Stock Products',
                    value: dashboard!['low_stock_products'],
                    icon: Icons.warning,
                    color: Colors.orange,
                  ),

                  buildCard(
                    title: 'Stock Adjustments',
                    value: dashboard!['stock_adjustments'],
                    icon: Icons.swap_vert,
                    color: Colors.green,
                  ),

                  buildCard(
                    title: 'Inventory Transactions',
                    value: dashboard!['inventory_transactions'],
                    icon: Icons.history,
                    color: Colors.purple,
                  ),

                  buildCard(
                    title: 'Inventory Value',
                    value: dashboard!['inventory_value'],
                    icon: Icons.payments,
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
    );
  }
}
