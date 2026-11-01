import 'package:flutter/material.dart';

import '../services/payment_service.dart';

class PaymentsScreen extends StatefulWidget {
  final int customerId;

  const PaymentsScreen({super.key, required this.customerId});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  List<dynamic> payments = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  Future<void> loadPayments() async {
    final data = await PaymentService().getPayments();

    setState(() {
      payments = data
          .where((payment) => payment['customer'] == widget.customerId)
          .toList();

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: payments.length,

              itemBuilder: (context, index) {
                final payment = payments[index];

                return Card(
                  child: ListTile(
                    title: Text('YER ${payment['amount']}'),

                    subtitle: Text(payment['payment_date']),

                    trailing: const Icon(Icons.payment),
                  ),
                );
              },
            ),
    );
  }
}
