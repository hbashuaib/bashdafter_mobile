import 'package:flutter/material.dart';

import '../services/reports_service.dart';

class CustomerSummaryScreen extends StatefulWidget {
  const CustomerSummaryScreen({super.key});

  @override
  State<CustomerSummaryScreen> createState() => _CustomerSummaryScreenState();
}

class _CustomerSummaryScreenState extends State<CustomerSummaryScreen> {
  List<dynamic> customers = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await ReportsService().getCustomerSummary();

    setState(() {
      customers = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Summary')),

      body: customers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: customers.length,

              itemBuilder: (context, index) {
                final customer = customers[index];

                return Card(
                  child: ListTile(
                    title: Text(customer['name']),

                    subtitle: Text(customer['phone']),

                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [Text('Bal: ${customer['balance']}')],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
