import 'package:flutter/material.dart';

import '../services/inactive_customer_service.dart';

class InactiveCustomersScreen extends StatefulWidget {
  const InactiveCustomersScreen({super.key});

  @override
  State<InactiveCustomersScreen> createState() =>
      _InactiveCustomersScreenState();
}

class _InactiveCustomersScreenState extends State<InactiveCustomersScreen> {
  final InactiveCustomerService _service = InactiveCustomerService();

  List<dynamic> customers = [];

  bool isLoading = true;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    loadCustomers();
  }

  Future<void> loadCustomers() async {
    try {
      final data = await _service.getInactiveCustomers();

      if (!mounted) return;

      setState(() {
        customers = data;
        errorMessage = null;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'Failed to load inactive customers';
        isLoading = false;
      });
    }
  }

  Future<void> showRestoreConfirmation(Map<String, dynamic> customer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Restore Customer'),
          content: Text(
            'Are you sure you want to restore ${customer['name']}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Restore'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await restoreCustomer(customer);
    }
  }

  Future<void> restoreCustomer(Map<String, dynamic> customer) async {
    try {
      await _service.restoreCustomer(customer['id']);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${customer['name']} restored successfully')),
      );

      await loadCustomers();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to restore customer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Inactive Customers')),
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Inactive Customers')),
      body: RefreshIndicator(
        onRefresh: loadCustomers,
        child: customers.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 150),
                  Center(child: Text('No inactive customers')),
                ],
              )
            : ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = customers[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          customer['name'].toString().isNotEmpty
                              ? customer['name'].toString()[0].toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(customer['name'].toString()),
                      subtitle: Text(customer['phone'].toString()),
                      trailing: IconButton(
                        icon: const Icon(Icons.restore, color: Colors.green),
                        onPressed: () {
                          showRestoreConfirmation(customer);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
