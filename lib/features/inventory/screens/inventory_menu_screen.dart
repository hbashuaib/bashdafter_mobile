import 'package:flutter/material.dart';

import 'inventory_history_screen.dart';
import 'stock_adjustment_screen.dart';

class InventoryMenuScreen extends StatelessWidget {
  const InventoryMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),

      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Inventory History'),
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

          const Divider(),

          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Stock Adjustments'),
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

          const Divider(),

          ListTile(
            leading: const Icon(Icons.warning),
            title: const Text('Low Stock Products'),
            trailing: const Icon(Icons.arrow_forward_ios),

            onTap: () {
              // next screen
            },
          ),
        ],
      ),
    );
  }
}
