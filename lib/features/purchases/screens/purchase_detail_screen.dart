import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';

class PurchaseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> purchase;
  const PurchaseDetailScreen({super.key, required this.purchase});

  String buildWhatsAppMessage(BuildContext context) {
    final buffer = StringBuffer();
    final totalAmount =
        double.tryParse(purchase['total_amount'].toString()) ?? 0;

    buffer.writeln('🧾 ${purchase['shop_name'] ?? 'Shop'}');
    buffer.writeln('Purchase Receipt Statement');
    buffer.writeln('');

    if (purchase['customer_name'] != null) {
      buffer.writeln('Customer: ${purchase['customer_name']}');
    }

    buffer.writeln('Date: ${purchase['purchase_date']}');
    buffer.writeln('');
    buffer.writeln('Items:');

    for (final item in purchase['items']) {
      buffer.writeln(
        '- ${item['item_name']}'
        ' x ${item['quantity']}',
      );
    }

    buffer.writeln('');

    buffer.writeln(
      'Total Amount: '
      '${AppFormatters.currency(context, totalAmount, context.read<ShopProvider>().currency)}',
    );

    buffer.writeln('');
    buffer.writeln('Thank you for your business.');
    buffer.writeln('BashDafter');
    return buffer.toString();
  }

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
                ShareParams(text: buildWhatsAppMessage(context)),
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
