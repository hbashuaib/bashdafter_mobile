import 'package:flutter/material.dart';

import '../services/customer_detail_service.dart';

class CustomerDetailScreen extends StatefulWidget {
  final int customerId;

  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  Map<String, dynamic>? customer;

  @override
  void initState() {
    super.initState();
    loadCustomer();
  }

  Future<void> loadCustomer() async {
    final data = await CustomerDetailService().getCustomer(widget.customerId);

    setState(() {
      customer = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (customer == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(customer!['name'])),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text('Phone: ${customer!['phone']}'),

            const SizedBox(height: 10),

            Text('Balance: ${customer!['balance']}'),

            const SizedBox(height: 10),

            Text('Address: ${customer!['address']}'),

            const SizedBox(height: 10),

            Text('Notes: ${customer!['notes']}'),
          ],
        ),
      ),
    );
  }
}
