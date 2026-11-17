import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/reports_service.dart';
import '../../../core/widgets/app_loading_scaffold.dart';
import '../../../core/widgets/app_refreshable_empty_state.dart';

class CustomerSummaryScreen extends StatefulWidget {
  const CustomerSummaryScreen({super.key});

  @override
  State<CustomerSummaryScreen> createState() => _CustomerSummaryScreenState();
}

class _CustomerSummaryScreenState extends State<CustomerSummaryScreen> {
  final currencyFormatter = NumberFormat('#,##0.00');
  final searchController = TextEditingController();
  List<dynamic> customers = [];
  List<dynamic> filteredCustomers = [];
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
        const SnackBar(content: Text('Failed to load customer summary')),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  double get totalOutstandingBalance {
    return customers.fold(
      0.0,
      (sum, customer) =>
          sum + (double.tryParse(customer['balance'].toString()) ?? 0),
    );
  }

  void searchCustomers(String value) {
    final query = value.toLowerCase().trim();

    setState(() {
      filteredCustomers = customers.where((customer) {
        final name = customer['name'].toString().toLowerCase();
        final phone = customer['phone'].toString().toLowerCase();
        final balance = customer['balance'].toString().toLowerCase();

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
      return const AppLoadingScaffold(message: 'Loading customer summary...');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Customer Summary')),

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
                      const Text('Customers'),

                      Text(
                        customers.length.toString(),

                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      const Text('Outstanding'),

                      Text(
                        'YER ${currencyFormatter.format(totalOutstandingBalance)}',

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

            child: TextField(
              controller: searchController,

              onChanged: (value) {
                searchCustomers(value);
                setState(() {});
              },

              decoration: InputDecoration(
                hintText: 'Search customer',

                prefixIcon: const Icon(Icons.search),

                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),

                        onPressed: () {
                          searchController.clear();
                          searchCustomers('');
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),

            child: Center(
              child: Text(
                'Showing ${filteredCustomers.length} of ${customers.length} customers',

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: filteredCustomers.isEmpty
                ? AppRefreshableEmptyState(
                    message: 'No customers found',
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
                        final balance =
                            double.tryParse(customer['balance'].toString()) ??
                            0;

                        return Card(
                          child: ListTile(
                            title: Text(
                              customer['name']?.toString() ??
                                  'Unknown Customer',
                            ),

                            subtitle: Text(
                              customer['phone']?.toString() ?? '-',
                            ),

                            trailing: Text(
                              'YER ${currencyFormatter.format(balance)}',
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
