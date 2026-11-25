import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/reports_service.dart';
import '../models/customer_summary_model.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';
import '../../../core/widgets/app_search_field.dart';

class CustomerSummaryScreen extends StatefulWidget {
  const CustomerSummaryScreen({super.key});

  @override
  State<CustomerSummaryScreen> createState() => _CustomerSummaryScreenState();
}

class _CustomerSummaryScreenState extends State<CustomerSummaryScreen> {
  final searchController = TextEditingController();
  List<CustomerSummaryModel> customers = [];
  List<CustomerSummaryModel> filteredCustomers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final data = await ReportsService().getCustomerSummary();

      if (!mounted) return;

      setState(() {
        customers = data;
        filteredCustomers = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadCustomerSummary)),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  double get totalOutstandingBalance {
    return customers.fold(
      0.0,
      (sum, customer) => sum + customer.balance.toDouble(),
    );
  }

  void searchCustomers(String value) {
    final query = value.toLowerCase().trim();

    setState(() {
      filteredCustomers = customers.where((customer) {
        final name = customer.name.toLowerCase();
        final phone = customer.phone.toLowerCase();
        final balance = customer.balance.toString().toLowerCase();

        return name.contains(query) ||
            phone.contains(query) ||
            balance.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return AppLoadingScaffold(message: context.l10n.loadingCustomerSummary);
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.customerSummary)),

      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),

            child: Padding(
              padding: const EdgeInsets.all(12),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  Column(
                    children: [
                      Text(context.l10n.customers),

                      Text(
                        // customers.length.toString(),
                        AppFormatters.number(context, customers.length),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Text(context.l10n.outstanding),

                      Text(
                        // 'YER ${currencyFormatter.format(totalOutstandingBalance)}',
                        AppFormatters.currency(
                          context,
                          totalOutstandingBalance,
                          context.read<ShopProvider>().currency,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: AppSearchField(
              controller: searchController,
              hintText: context.l10n.searchCustomer,

              onChanged: searchCustomers,

              onClear: () {
                searchController.clear();
                searchCustomers('');
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: Center(
              child: Text(
                '${context.l10n.showing} '
                '${AppFormatters.number(context, filteredCustomers.length)} '
                '${context.l10n.outOf} '
                '${AppFormatters.number(context, customers.length)} '
                '${context.l10n.customers}',

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: filteredCustomers.isEmpty
                ? AppRefreshableEmptyState(
                    message: context.l10n.noCustomersFound,
                    icon: Icons.people_outline,
                    onRefresh: loadData,
                  )
                : RefreshIndicator(
                    onRefresh: loadData,

                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: filteredCustomers.length,

                      itemBuilder: (context, index) {
                        final customer = filteredCustomers[index];
                        final balance = customer.balance.toDouble();

                        return Card(
                          child: ListTile(
                            title: Text(
                              customer.name.isEmpty
                                  ? context.l10n.unknownCustomer
                                  : customer.name,
                            ),

                            subtitle: Text(
                              customer.phone.isEmpty ? '-' : customer.phone,
                            ),

                            trailing: Text(
                              // 'YER ${currencyFormatter.format(balance)}',
                              AppFormatters.currency(
                                context,
                                balance,
                                context.read<ShopProvider>().currency,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
