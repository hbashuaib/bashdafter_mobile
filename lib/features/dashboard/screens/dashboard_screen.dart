import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/dashboard_service.dart';
import '../models/dashboard_model.dart';
import '../../../core/storage/token_storage.dart';
import '../../auth/screens/login_screen.dart';
import '../../inventory/screens/inventory_menu_screen.dart';
import '../../voice/screens/voice_recorder_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardModel? dashboardData;
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
    } on DioException catch (e) {
      if (!mounted) return;

      if (e.response?.statusCode == 401) {
        await TokenStorage.clear();

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadDashboard)),
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadDashboard)),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalBalance = dashboardData?.totalBalance.toDouble() ?? 0;
    final hasBalance = totalBalance > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.dashboard),

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
          ? Center(child: Text(context.l10n.noDashboardDataAvailable))
          : RefreshIndicator(
              onRefresh: loadDashboard,

              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),

                padding: const EdgeInsets.all(20),

                children: [
                  Card(
                    color: AppColors.cardTint(context, Colors.indigo.shade50),

                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Row(
                        children: [
                          Icon(Icons.dashboard, size: 40, color: Colors.indigo),
                          SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  context.l10n.businessDashboard,

                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(context.l10n.businessDashboardDescription),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          Column(
                            children: [
                              Text(context.l10n.customersCount),

                              Text(
                                AppFormatters.number(
                                  context,
                                  dashboardData!.customers,
                                ),

                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),

                          Column(
                            children: [
                              Text(context.l10n.balance),

                              Text(
                                // 'YER ${currencyFormatter.format(totalBalance)}',
                                AppFormatters.currency(
                                  context,
                                  totalBalance,
                                  context.read<ShopProvider>().currency,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8, left: 4),

                    child: Align(
                      alignment: AlignmentDirectional.centerStart,

                      child: Text(
                        context.l10n.businessOverview,

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Card(
                    color: AppColors.cardTint(context, Colors.blue.shade50),
                    child: ListTile(
                      leading: const Icon(Icons.people, color: Colors.blue),
                      title: Text(context.l10n.customersCount),
                      trailing: Text(
                        AppFormatters.number(context, dashboardData!.customers),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Card(
                    color: AppColors.cardTint(context, Colors.orange.shade50),
                    child: ListTile(
                      leading: const Icon(
                        Icons.shopping_cart,
                        color: Colors.orange,
                      ),
                      title: Text(context.l10n.totalPurchases),
                      trailing: Text(
                        AppFormatters.currency(
                          context,
                          dashboardData!.totalPurchases.toDouble(),
                          context.read<ShopProvider>().currency,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Card(
                    color: AppColors.cardTint(context, Colors.green.shade50),
                    child: ListTile(
                      leading: const Icon(Icons.payments, color: Colors.green),
                      title: Text(context.l10n.totalPayments),
                      trailing: Text(
                        AppFormatters.currency(
                          context,
                          dashboardData!.totalPayments.toDouble(),
                          context.read<ShopProvider>().currency,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Card(
                    color: AppColors.cardTint(
                      context,
                      hasBalance ? Colors.orange.shade50 : Colors.green.shade50,
                    ),

                    child: ListTile(
                      leading: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.purple,
                      ),
                      title: Text(context.l10n.balance),
                      trailing: Text(
                        // 'YER ${currencyFormatter.format(totalBalance)}',
                        AppFormatters.currency(
                          context,
                          totalBalance,
                          context.read<ShopProvider>().currency,
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: hasBalance ? Colors.orange : Colors.green,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8, left: 4),

                    child: Align(
                      alignment: AlignmentDirectional.centerStart,

                      child: Text(
                        context.l10n.quickActions,

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.inventory, color: Colors.blue),
                      title: Text(context.l10n.inventoryManagement),

                      subtitle: Text(
                        context.l10n.inventoryManagementDescription,
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

                  Card(
                    color: AppColors.cardTint(context, Colors.red.shade50),

                    child: ListTile(
                      leading: const Icon(Icons.mic, color: Colors.red),
                      title: Text(context.l10n.voiceEntry),
                      subtitle: Text(context.l10n.voiceEntryDescription),
                      trailing: const Icon(Icons.arrow_forward_ios),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VoiceRecorderScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 140),
                ],
              ),
            ),
    );
  }
}
