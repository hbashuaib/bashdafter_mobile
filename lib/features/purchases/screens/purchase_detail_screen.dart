import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/localization/localization_extension.dart';

class PurchaseDetailScreen extends StatelessWidget {
  final Map<String, dynamic> purchase;
  final NumberFormat currencyFormatter = NumberFormat('#,##0.00');

  PurchaseDetailScreen({super.key, required this.purchase});

  String buildWhatsAppMessage() {
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
      'YER ${currencyFormatter.format(totalAmount)}',
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
            child: ListTile(
              title: Text(context.l10n.purchaseDate),
              subtitle: Text(purchase['purchase_date'].toString()),
            ),
          ),

          Card(
            child: ListTile(
              title: Text(context.l10n.totalAmount),
              subtitle: Text('YER ${currencyFormatter.format(totalAmount)}'),
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
                  '${item['quantity']} x ${currencyFormatter.format(unitPrice)}',
                ),
                trailing: Text(
                  currencyFormatter.format(totalPrice),
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
