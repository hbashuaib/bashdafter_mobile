import 'package:flutter/material.dart';

import 'inventory_history_screen.dart';
import 'stock_adjustment_screen.dart';
import 'low_stock_products_screen.dart';
import 'inventory_dashboard_screen.dart';
import 'top_selling_products_screen.dart';

class InventoryMenuScreen extends StatelessWidget {
  const InventoryMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),

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
                    'Inventory Management',

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 8),

                  Text('Manage stock operations and inventory reports'),
                ],
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.blue),

              title: const Text('Inventory Dashboard'),

              subtitle: const Text('Inventory statistics and summary'),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InventoryDashboardScreen(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events, color: Colors.amber),

              title: const Text('Top Selling Products'),

              subtitle: const Text('Best performing products'),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TopSellingProductsScreen(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.history, color: Colors.purple),

              title: const Text('Inventory History'),

              subtitle: const Text('All inventory transactions'),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InventoryHistoryScreen(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory, color: Colors.green),

              title: const Text('Stock Adjustments'),

              subtitle: const Text('Increase or decrease stock'),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StockAdjustmentScreen(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.warning, color: Colors.orange),

              title: const Text('Low Stock Products'),

              subtitle: const Text('Products requiring replenishment'),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LowStockProductsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
