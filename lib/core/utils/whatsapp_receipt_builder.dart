import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/localization_extension.dart';
import '../localization/app_formatters.dart';
import '../providers/shop_provider.dart';

class WhatsAppReceiptBuilder {
  WhatsAppReceiptBuilder._();

  static String purchaseReceipt(
    BuildContext context,
    Map<String, dynamic> purchase,
  ) {
    final buffer = StringBuffer();

    final totalAmount =
        double.tryParse(purchase['total_amount'].toString()) ?? 0;

    buffer.writeln('🧾 ${purchase['shop_name'] ?? 'BashDafter Shop'}');

    buffer.writeln(context.l10n.purchaseReceiptStatement);

    buffer.writeln('');

    if (purchase['customer_name'] != null) {
      buffer.writeln(
        '${context.l10n.customerLabel}: '
        '${purchase['customer_name']}',
      );
    }

    if (purchase['purchase_date'] != null) {
      buffer.writeln(
        '${context.l10n.dateLabel}: '
        '${AppFormatters.date(context, DateTime.parse(purchase['purchase_date'].toString()))}',
      );
    }

    buffer.writeln('');
    buffer.writeln(context.l10n.itemsLabel);
    buffer.writeln('');

    for (final item in (purchase['items'] as List? ?? [])) {
      final quantity = double.tryParse(item['quantity'].toString()) ?? 0;

      buffer.writeln(
        '- ${item['item_name']} '
        '× '
        '${AppFormatters.number(context, quantity)}',
      );
    }

    buffer.writeln('');

    buffer.writeln(
      '${context.l10n.totalAmountLabel}: '
      '${AppFormatters.currency(context, totalAmount, context.read<ShopProvider>().currency)}',
    );

    final notes = (purchase['notes'] ?? '').toString().trim();

    if (notes.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('${context.l10n.notes}:');
      buffer.writeln(notes);
    }

    buffer.writeln('');
    buffer.writeln(context.l10n.thankYouForBusiness);

    buffer.writeln('');
    buffer.writeln(context.l10n.poweredByBashDafter);

    return buffer.toString();
  }

  static String paymentReceipt(
    BuildContext context,
    Map<String, dynamic> payment,
  ) {
    final buffer = StringBuffer();
    final amount = double.tryParse(payment['amount'].toString()) ?? 0;
    buffer.writeln('💰 ${payment['shop_name'] ?? 'BashDafter'}');
    buffer.writeln(context.l10n.paymentReceiptStatement);
    buffer.writeln('');

    if (payment['customer_name'] != null) {
      buffer.writeln(
        '${context.l10n.customerLabel}: '
        '${payment['customer_name']}',
      );
    }

    if (payment['payment_date'] != null) {
      buffer.writeln(
        '${context.l10n.dateLabel}: '
        '${AppFormatters.date(context, DateTime.parse(payment['payment_date'].toString()))}',
      );
    }

    buffer.writeln('');

    buffer.writeln('${context.l10n.paymentAmountLabel}:');

    buffer.writeln(
      AppFormatters.currency(
        context,
        amount,
        context.read<ShopProvider>().currency,
      ),
    );

    final notes = (payment['notes'] ?? '').toString().trim();

    if (notes.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('${context.l10n.notes}:');
      buffer.writeln(notes);
    }

    buffer.writeln('');

    buffer.writeln(context.l10n.thankYouForPayment);

    buffer.writeln('');

    buffer.writeln(context.l10n.poweredByBashDafter);

    return buffer.toString();
  }

  static String customerStatement(
    BuildContext context,
    Map<String, dynamic> statement,
    List<dynamic> transactions,
  ) {
    final buffer = StringBuffer();

    final balance = double.tryParse(statement['balance'].toString()) ?? 0;

    buffer.writeln('📋 ${statement['shop_name'] ?? 'BashDafter'}');

    buffer.writeln(context.l10n.customerStatementTitle);

    buffer.writeln('');

    buffer.writeln(
      '${context.l10n.customerLabel}: '
      '${statement['customer']}',
    );

    if (statement['phone'] != null &&
        statement['phone'].toString().trim().isNotEmpty) {
      buffer.writeln(
        '${context.l10n.phoneLabel}: '
        '${statement['phone']}',
      );
    }

    buffer.writeln('');

    buffer.writeln('${context.l10n.currentBalanceLabel}:');

    buffer.writeln(
      AppFormatters.currency(
        context,
        balance,
        context.read<ShopProvider>().currency,
      ),
    );

    buffer.writeln('');
    buffer.writeln('${context.l10n.transactionsLabel}:');
    buffer.writeln('');

    for (final item in transactions) {
      final isPurchase = item['type'] == 'purchase';

      final amount = double.tryParse(item['amount'].toString()) ?? 0;

      final transactionDate = DateTime.tryParse(item['date'].toString());

      final dateText = transactionDate == null
          ? item['date'].toString()
          : AppFormatters.date(context, transactionDate);

      buffer.writeln(
        '$dateText'
        ' | '
        '${isPurchase ? '🛒 ${context.l10n.purchaseReceiptType}' : '💰 ${context.l10n.paymentReceiptType}'}'
        ' | '
        '${isPurchase ? '+' : '-'}'
        '${AppFormatters.currency(context, amount, context.read<ShopProvider>().currency)}',
      );
    }

    buffer.writeln('');
    buffer.writeln(context.l10n.poweredByBashDafter);

    return buffer.toString();
  }
}
