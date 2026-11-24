import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/localization_extension.dart';
import '../localization/app_formatters.dart';
import '../providers/shop_provider.dart';
import '../../features/purchases/models/purchase_model.dart';
import '../../features/payments/models/payment_model.dart';
import '../../features/reports/models/customer_statement_model.dart';
import '../../features/reports/models/customer_statement_transaction_model.dart';

class WhatsAppReceiptBuilder {
  WhatsAppReceiptBuilder._();

  static String purchaseReceipt(BuildContext context, PurchaseModel purchase) {
    final buffer = StringBuffer();
    final totalAmount = double.tryParse(purchase.totalAmount) ?? 0;
    buffer.writeln(
      '🧾 ${purchase.shopName.isEmpty ? 'BashDafter Shop' : purchase.shopName}',
    );
    buffer.writeln(context.l10n.purchaseReceiptStatement);

    buffer.writeln('');

    if (purchase.customerName.isNotEmpty) {
      buffer.writeln(
        '${context.l10n.customerLabel}: '
        '${purchase.customerName}',
      );
    }

    if (purchase.purchaseDate.isNotEmpty) {
      buffer.writeln(
        '${context.l10n.dateLabel}: '
        '${AppFormatters.date(context, DateTime.parse(purchase.purchaseDate))}',
      );
    }

    buffer.writeln('');
    buffer.writeln(context.l10n.itemsLabel);
    buffer.writeln('');

    for (final item in purchase.items) {
      final quantity = double.tryParse(item.quantity) ?? 0;

      buffer.writeln(
        '- ${item.itemName} '
        '× '
        '${AppFormatters.number(context, quantity)}',
      );
    }

    buffer.writeln('');

    buffer.writeln(
      '${context.l10n.totalAmountLabel}: '
      '${AppFormatters.currency(context, totalAmount, context.read<ShopProvider>().currency)}',
    );

    final notes = purchase.notes.trim();

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

  static String paymentReceipt(BuildContext context, PaymentModel payment) {
    final buffer = StringBuffer();
    final amount = double.tryParse(payment.amount) ?? 0;
    buffer.writeln(
      '💰 ${payment.shopName.isEmpty ? 'BashDafter' : payment.shopName}',
    );
    buffer.writeln(context.l10n.paymentReceiptStatement);
    buffer.writeln('');

    if (payment.customerName.isNotEmpty) {
      buffer.writeln(
        '${context.l10n.customerLabel}: '
        '${payment.customerName}',
      );
    }

    if (payment.paymentDate.isNotEmpty) {
      buffer.writeln(
        '${context.l10n.dateLabel}: '
        '${AppFormatters.date(context, DateTime.parse(payment.paymentDate))}',
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

    final notes = payment.notes.trim();

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
    CustomerStatementModel statement,
    List<CustomerStatementTransactionModel> transactions,
  ) {
    final buffer = StringBuffer();
    final balance = statement.balance.toDouble();

    buffer.writeln(
      '📋 ${statement.shopName.isEmpty ? 'BashDafter' : statement.shopName}',
    );

    buffer.writeln(context.l10n.customerStatementTitle);

    buffer.writeln('');

    buffer.writeln(
      '${context.l10n.customerLabel}: '
      '${statement.customer}',
    );

    if (statement.phone.trim().isNotEmpty) {
      buffer.writeln(
        '${context.l10n.phoneLabel}: '
        '${statement.phone}',
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
      final isPurchase = item.type == 'purchase';
      final amount = item.amount.toDouble();
      final transactionDate = DateTime.tryParse(item.date);

      final dateText = transactionDate == null
          ? item.date
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
