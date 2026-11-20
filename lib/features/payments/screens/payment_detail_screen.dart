import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';

class PaymentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> payment;
  final NumberFormat currencyFormatter = NumberFormat('#,##0.00');

  PaymentDetailScreen({super.key, required this.payment});

  String buildWhatsAppMessage() {
    final buffer = StringBuffer();
    final amount = double.tryParse(payment['amount'].toString()) ?? 0;

    buffer.writeln('💰 ${payment['shop_name'] ?? 'Shop'}');
    buffer.writeln('Payment Receipt Statement');
    buffer.writeln('');

    if (payment['customer_name'] != null) {
      buffer.writeln('Customer: ${payment['customer_name']}');
    }

    buffer.writeln('Date: ${payment['payment_date']}');
    buffer.writeln('');
    buffer.writeln('Payment Amount:');
    buffer.writeln('YER ${currencyFormatter.format(amount)}');

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
    final amount = double.tryParse(payment['amount'].toString()) ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.paymentDetails),

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
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),

        children: [
          Card(
            color: AppColors.cardTint(context, Colors.green.shade50),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  const Icon(Icons.payment, color: Colors.green, size: 40),

                  const SizedBox(height: 10),

                  Text(
                    context.l10n.paymentReceipt,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Card(
            color: AppColors.cardTint(context, Colors.green.shade50),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  Text(
                    context.l10n.paymentAmount,
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'YER ${currencyFormatter.format(amount)}',
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

              title: Text(context.l10n.paymentDate),

              subtitle: Text(payment['payment_date']?.toString() ?? '-'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long),

              title: Text(context.l10n.paymentId),

              subtitle: Text(payment['id']?.toString() ?? '-'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.notes),

              title: Text(context.l10n.notes),

              subtitle: Text(
                (payment['notes'] ?? '').toString().trim().isEmpty
                    ? context.l10n.noNotes
                    : payment['notes'].toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
