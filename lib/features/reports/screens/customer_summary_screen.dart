import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/reports_service.dart';

class CustomerSummaryScreen extends StatefulWidget {
  const CustomerSummaryScreen({super.key});

  @override
  State<CustomerSummaryScreen> createState() => _CustomerSummaryScreenState();
}

class _CustomerSummaryScreenState extends State<CustomerSummaryScreen> {
  final currencyFormatter = NumberFormat('#,##0.00');
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

  void searchCustomers(String value) {
    final query = value.toLowerCase();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Summary')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            const Text('Outstanding'),

                            Text(
                              'YER ${currencyFormatter.format(customers.fold(0.0, (sum, customer) => sum + (double.tryParse(customer['balance'].toString()) ?? 0)))}',

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
                    onChanged: searchCustomers,

                    decoration: const InputDecoration(
                      hintText: 'Search customer',

                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),

                Center(
                  child: Text(
                    'Showing ${filteredCustomers.length} of ${customers.length} customers',

                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                Expanded(
                  child: customers.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 150),

                            Center(child: Text('No customers found')),
                          ],
                        )
                      : RefreshIndicator(
                          onRefresh: loadData,

                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: filteredCustomers.length,

                            itemBuilder: (context, index) {
                              final customer = filteredCustomers[index];

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
                                    'YER ${currencyFormatter.format(double.tryParse(customer['balance'].toString()) ?? 0)}',
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
