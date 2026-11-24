import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';

import '../models/payment_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';
import '../../../core/utils/whatsapp_receipt_builder.dart';

class PaymentDetailScreen extends StatelessWidget {
  final PaymentModel payment;
  const PaymentDetailScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    final amount = double.tryParse(payment.amount) ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.paymentDetails),

        actions: [
          IconButton(
            icon: const Icon(Icons.share),

            onPressed: () {
              SharePlus.instance.share(
                ShareParams(
                  text: WhatsAppReceiptBuilder.paymentReceipt(context, payment),
                ),
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
                    // 'YER ${currencyFormatter.format(amount)}',
                    AppFormatters.currency(
                      context,
                      amount,
                      context.read<ShopProvider>().currency,
                    ),
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

              subtitle: Text(
                payment.paymentDate.isEmpty
                    ? '-'
                    : AppFormatters.date(
                        context,
                        DateTime.parse(payment.paymentDate),
                      ),
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long),
              title: Text(context.l10n.paymentId),
              subtitle: Text(AppFormatters.number(context, payment.id)),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.notes),

              title: Text(context.l10n.notes),

              subtitle: Text(
                payment.notes.trim().isEmpty
                    ? context.l10n.noNotes
                    : payment.notes,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
