import 'package:flutter/material.dart';

import '../services/customer_service.dart';
import 'customer_detail_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<dynamic> customers = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    final data = await CustomerService().getCustomers();

    setState(() {
      customers = data;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: customers.length,

              itemBuilder: (context, index) {
                final customer = customers[index];

                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CustomerDetailScreen(customerId: customer['id']),
                        ),
                      );
                    },

                    title: Text(customer['name']),

                    subtitle: Text(customer['phone']),

                    trailing: Chip(label: Text(customer['balance'].toString())),
                  ),
                );
              },
            ),
    );
  }
}
