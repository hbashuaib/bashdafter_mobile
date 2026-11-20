import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/inventory_dashboard_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';

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
        SnackBar(content: Text(context.l10n.failedToLoadInventoryDashboard)),
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
    required bool isInventoryValue,
    required bool isExpiring,
  }) {
    return Card(
      color: isInventoryValue
          ? AppColors.cardTint(context, Colors.teal.shade50)
          : isExpiring
          ? AppColors.cardTint(context, Colors.red.shade50)
          : null,

      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: isInventoryValue
            ? Text(context.l10n.currentStockValue)
            : null,

        trailing: Text(
          isInventoryValue
              ? 'YER ${currencyFormatter.format(double.tryParse(value.toString()) ?? 0)}'
              : value.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isInventoryValue
                ? Colors.teal.shade700
                : isExpiring
                ? Colors.red.shade700
                : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.inventoryDashboard)),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboard == null
          ? Center(child: Text(context.l10n.noInventoryDataAvailable))
          : RefreshIndicator(
              onRefresh: loadDashboard,

              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),

                children: [
                  Card(
                    color: AppColors.cardTint(context, Colors.indigo.shade50),

                    child: Padding(
                      padding: const EdgeInsets.all(16),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          Column(
                            children: [
                              Text(context.l10n.products),

                              Text(
                                dashboard!['total_products'].toString(),

                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Column(
                            children: [
                              Text(context.l10n.lowStock),

                              Text(
                                dashboard!['low_stock_products'].toString(),

                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          Column(
                            children: [
                              Text(context.l10n.expiring),

                              Text(
                                dashboard!['expiring_products'].toString(),

                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  buildCard(
                    title: context.l10n.totalProducts,
                    isInventoryValue: false,
                    isExpiring: false,
                    value: dashboard!['total_products'],
                    icon: Icons.inventory_2,
                    color: Colors.blue,
                  ),

                  buildCard(
                    title: context.l10n.lowStockProducts,
                    isInventoryValue: false,
                    isExpiring: false,
                    value: dashboard!['low_stock_products'],
                    icon: Icons.warning,
                    color: Colors.orange,
                  ),

                  buildCard(
                    title: context.l10n.expiringProducts,
                    isInventoryValue: false,
                    isExpiring: true,
                    value: dashboard!['expiring_products'],
                    icon: Icons.calendar_month,
                    color: Colors.red,
                  ),

                  buildCard(
                    title: context.l10n.stockAdjustments,
                    isInventoryValue: false,
                    isExpiring: false,
                    value: dashboard!['stock_adjustments'],
                    icon: Icons.swap_vert,
                    color: Colors.green,
                  ),

                  buildCard(
                    title: context.l10n.inventoryTransactions,
                    isInventoryValue: false,
                    isExpiring: false,
                    value: dashboard!['inventory_transactions'],
                    icon: Icons.history,
                    color: Colors.purple,
                  ),

                  buildCard(
                    title: context.l10n.inventoryValue,
                    isInventoryValue: true,
                    isExpiring: false,
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
