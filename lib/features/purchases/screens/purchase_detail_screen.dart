import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';
import '../../../core/utils/whatsapp_receipt_builder.dart';

class PurchaseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> purchase;
  const PurchaseDetailScreen({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    final totalAmount =
        double.tryParse(purchase['total_amount'].toString()) ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.purchaseDetails),

        actions: [
          IconButton(
            icon: const Icon(Icons.share),

            onPressed: () {
              SharePlus.instance.share(
                ShareParams(
                  text: WhatsAppReceiptBuilder.purchaseReceipt(
                    context,
                    purchase,
                  ),
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
            child: ListTile(
              title: Text(context.l10n.purchaseDate),
              subtitle: Text(
                AppFormatters.date(
                  context,
                  DateTime.parse(purchase['purchase_date'].toString()),
                ),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: Text(context.l10n.totalAmount),
              subtitle: Text(
                // 'YER ${currencyFormatter.format(totalAmount)}',
                AppFormatters.currency(
                  context,
                  totalAmount,
                  context.read<ShopProvider>().currency,
                ),
              ),
            ),
          ),

          Card(
            child: ListTile(
              title: Text(context.l10n.notes),
              subtitle: Text(
                (purchase['notes'] ?? '').toString().trim().isEmpty
                    ? context.l10n.noNotes
                    : purchase['notes'],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            context.l10n.items,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ...((purchase['items'] as List? ?? [])).map((item) {
            final unitPrice =
                double.tryParse(item['unit_price'].toString()) ?? 0;

            final totalPrice =
                double.tryParse(item['total_price'].toString()) ?? 0;

            return Card(
              child: ListTile(
                title: Text(item['item_name']),
                subtitle: Text(
                  '${item['quantity']} x ${
                  // currencyFormatter.format(unitPrice)
                  AppFormatters.currency(context, unitPrice, context.read<ShopProvider>().currency)}',
                ),
                trailing: Text(
                  // currencyFormatter.format(totalPrice),
                  AppFormatters.currency(
                    context,
                    totalPrice,
                    context.read<ShopProvider>().currency,
                  ),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
