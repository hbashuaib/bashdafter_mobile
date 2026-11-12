import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class PaymentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> payment;
  final NumberFormat currencyFormatter = NumberFormat('#,##0.00');

  PaymentDetailScreen({super.key, required this.payment});

  String buildWhatsAppMessage() {
    final buffer = StringBuffer();
    buffer.writeln('💰 ${payment['shop_name'] ?? 'Shop'}');
    buffer.writeln('Payment Receipt');
    buffer.writeln('');

    if (payment['customer_name'] != null) {
      buffer.writeln('Customer: ${payment['customer_name']}');
    }

    buffer.writeln('Date: ${payment['payment_date']}');
    buffer.writeln('');
    buffer.writeln('Payment Amount:');
    buffer.writeln(
      'YER ${currencyFormatter.format(double.tryParse(payment['amount'].toString()) ?? 0)}',
    );

    if ((payment['notes'] ?? '').toString().trim().isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('Notes:');
      buffer.writeln(payment['notes']);
    }

    buffer.writeln('');
    buffer.writeln('Thank you for your payment.');
    buffer.writeln('');
    buffer.writeln('Powered by BashDafter');
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),

        actions: [
          IconButton(
            icon: const Icon(Icons.share),

            onPressed: () {
              SharePlus.instance.share(
                ShareParams(text: buildWhatsAppMessage()),
              );
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          Card(
            color: Colors.green.shade50,

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  const Icon(Icons.payment, color: Colors.green, size: 40),

                  const SizedBox(height: 10),

                  const Text(
                    'PAYMENT RECEIPT',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          Card(
            color: Colors.green.shade50,

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  const Text('Payment Amount', style: TextStyle(fontSize: 16)),

                  const SizedBox(height: 12),

                  Text(
                    'YER ${currencyFormatter.format(double.tryParse(payment['amount'].toString()) ?? 0)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_today),

              title: const Text('Payment Date'),

              subtitle: Text(payment['payment_date']?.toString() ?? '-'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long),

              title: const Text('Payment ID'),

              subtitle: Text(payment['id']?.toString() ?? '-'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.notes),

              title: const Text('Notes'),

              subtitle: Text(
                (payment['notes'] ?? '').toString().trim().isEmpty
                    ? 'No notes'
                    : payment['notes'].toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
