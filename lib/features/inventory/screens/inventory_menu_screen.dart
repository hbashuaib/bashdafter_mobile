import 'package:flutter/material.dart';

import '../../../core/storage/token_storage.dart';
import '../../auth/models/user_profile.dart';
import '../../products/screens/expiring_products_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';

import 'inventory_history_screen.dart';
import 'stock_adjustment_screen.dart';
import 'low_stock_products_screen.dart';
import 'inventory_dashboard_screen.dart';
import 'top_selling_products_screen.dart';
import 'inventory_lookup_screen.dart';

class InventoryMenuScreen extends StatefulWidget {
  const InventoryMenuScreen({super.key});

  @override
  State<InventoryMenuScreen> createState() => _InventoryMenuScreenState();
}

class _InventoryMenuScreenState extends State<InventoryMenuScreen> {
  UserProfile? currentUser;

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    final profile = await TokenStorage.getProfile();

    if (!mounted) return;

    setState(() {
      currentUser = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.inventoryManagement)),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
        children: [
          Card(
            color: AppColors.cardTint(context, Colors.blue.shade50),

            child: Padding(
              padding: EdgeInsets.all(16),

              child: Row(
                children: [
                  Icon(Icons.inventory_2, size: 40, color: Colors.blue),

                  SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          context.l10n.inventoryManagement,

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(context.l10n.inventoryManagementDescription),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 12, bottom: 8, left: 8),

            child: Align(
              alignment: AlignmentDirectional.centerStart,

              child: Text(
                context.l10n.inventoryFunctions,

                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.blue),
              title: Text(context.l10n.inventoryDashboard),
              subtitle: Text(context.l10n.inventoryDashboardDescription),
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
              leading: const Icon(Icons.qr_code_scanner, color: Colors.indigo),
              title: Text(context.l10n.inventoryLookup),
              subtitle: Text(context.l10n.inventoryLookupDescription),
              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InventoryLookupScreen(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.warning, color: Colors.orange),
              title: Text(context.l10n.lowStockProducts),
              subtitle: Text(context.l10n.lowStockProductsDescription),
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

          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_month, color: Colors.orange),
              title: Text(context.l10n.expiringProducts),
              subtitle: Text(context.l10n.expiringProductsDescription),
              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ExpiringProductsScreen(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events, color: Colors.amber),
              title: Text(context.l10n.topSellingProducts),
              subtitle: Text(context.l10n.topSellingProductsDescription),
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
              title: Text(context.l10n.inventoryHistory),
              subtitle: Text(context.l10n.inventoryHistoryDescription),
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

          if (currentUser != null && !currentUser!.isCashier)
            Card(
              child: ListTile(
                leading: const Icon(Icons.inventory, color: Colors.green),
                title: Text(context.l10n.stockAdjustments),
                subtitle: Text(context.l10n.stockAdjustmentsDescription),
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
        ],
      ),
    );
  }
}
