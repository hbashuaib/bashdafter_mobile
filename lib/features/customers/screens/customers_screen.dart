import 'package:flutter/material.dart';

import '../services/customer_service.dart';
import 'customer_detail_screen.dart';
import 'add_customer_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<dynamic> customers = [];
  List<dynamic> filteredCustomers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  void searchCustomers(String value) {
    setState(() {
      filteredCustomers = customers.where((customer) {
        final name = customer['name'].toString().toLowerCase();

        return name.contains(value.toLowerCase());
      }).toList();
    });
  }

  Future<void> loadCustomers() async {
    final data = await CustomerService().getCustomers();

    setState(() {
      customers = data;
      filteredCustomers = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),

        actions: [
          IconButton(
            icon: const Icon(Icons.add),

            onPressed: () async {
              final result = await Navigator.push(
                context,

                MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
              );

              if (result == true) {
                loadCustomers();
              }
            },
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),

                  child: TextField(
                    onChanged: searchCustomers,

                    decoration: const InputDecoration(
                      hintText: 'Search customer...',

                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCustomers.length,

                    itemBuilder: (context, index) {
                      final customer = filteredCustomers[index];

                      return Card(
                        child: ListTile(
                          onTap: () async {
                            await Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) => CustomerDetailScreen(
                                  customerId: customer['id'],
                                ),
                              ),
                            );

                            loadCustomers();
                          },

                          title: Text(customer['name']),

                          subtitle: Text(customer['phone']),

                          trailing: Chip(
                            label: Text(customer['balance'].toString()),
                          ),
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
