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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Summary')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : customers.isEmpty
          ? const Center(child: Text('No customers found'))
          : RefreshIndicator(
              onRefresh: loadData,

              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: customers.length,

                itemBuilder: (context, index) {
                  final customer = customers[index];

                  return Card(
                    child: ListTile(
                      title: Text(
                        customer['name']?.toString() ?? 'Unknown Customer',
                      ),

                      subtitle: Text(customer['phone']?.toString() ?? '-'),

                      trailing: Text(
                        'YER ${currencyFormatter.format(double.tryParse(customer['balance'].toString()) ?? 0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
