import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/inventory_dashboard_service.dart';

class InventoryDashboardScreen extends StatefulWidget {
  const InventoryDashboardScreen({super.key});

  @override
  State<InventoryDashboardScreen> createState() =>
      _InventoryDashboardScreenState();
}

class _InventoryDashboardScreenState extends State<InventoryDashboardScreen> {
  final currencyFormatter = NumberFormat('#,##0.00');
  Map<String, dynamic>? dashboard;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      setState(() {
        isLoading = true;
      });

      final data = await InventoryDashboardService().getDashboard();

      if (!mounted) return;

      setState(() {
        dashboard = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load inventory dashboard')),
      );

      setState(() {
        isLoading = false;
      });
    }
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
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

        trailing: Text(
          title == 'Inventory Value'
              ? 'YER ${currencyFormatter.format(double.tryParse(value.toString()) ?? 0)}'
              : value.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: title == 'Inventory Value' ? Colors.teal.shade700 : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Dashboard')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboard == null
          ? const Center(child: Text('No inventory data available'))
          : RefreshIndicator(
              onRefresh: loadDashboard,

              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
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

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
