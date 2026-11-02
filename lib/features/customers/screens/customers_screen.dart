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
  String currentFilter = 'active';

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

  void applyFilter() {
    if (currentFilter == 'all') {
      filteredCustomers = customers;
    } else if (currentFilter == 'active') {
      filteredCustomers = customers
          .where((customer) => customer['is_active'])
          .toList();
    } else {
      filteredCustomers = customers
          .where((customer) => !customer['is_active'])
          .toList();
    }

    setState(() {});
  }

  Future<void> loadCustomers() async {
    final data = await CustomerService().getCustomers();

    setState(() {
      customers = data;
      applyFilter();
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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),

                  child: Wrap(
                    spacing: 8,

                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: currentFilter == 'all',

                        onSelected: (_) {
                          currentFilter = 'all';
                          applyFilter();
                        },
                      ),

                      ChoiceChip(
                        label: const Text('Active'),
                        selected: currentFilter == 'active',

                        onSelected: (_) {
                          currentFilter = 'active';
                          applyFilter();
                        },
                      ),

                      ChoiceChip(
                        label: const Text('Inactive'),
                        selected: currentFilter == 'inactive',

                        onSelected: (_) {
                          currentFilter = 'inactive';
                          applyFilter();
                        },
                      ),
                    ],
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
