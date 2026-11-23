import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';

import '../../settings/services/shop_service.dart';
import '../../../core/utils/pdf_formatters.dart';
import '../../../core/utils/pdf_arabic_helper.dart';
import '../../../core/localization/localization_extension.dart';

class CustomerStatementPdfService {
  pw.Widget pdfLabel({
    required bool isArabic,
    required pw.Font arabicFont,
    required String text,
    bool bold = false,
    PdfColor? color,
    double? fontSize,
  }) {
    final style = pw.TextStyle(
      font: isArabic ? arabicFont : null,
      fontSize: fontSize,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      color: color,
    );

    return isArabic
        ? PdfArabicHelper.rtl(
            child: pw.Text(PdfArabicHelper.text(text), style: style),
          )
        : pw.Text(text, style: style);
  }

  pw.Widget summaryRow({
    required bool isArabic,
    required pw.Font arabicFont,
    required String label,
    required String value,
    PdfColor? valueColor,
  }) {
    return pw.Directionality(
      textDirection: isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,

      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

        children: [
          pdfLabel(
            isArabic: isArabic,
            arabicFont: arabicFont,
            text: label,
            bold: true,
          ),

          isArabic
              ? PdfArabicHelper.rtl(
                  child: pw.Text(
                    value,
                    style: pw.TextStyle(font: arabicFont, color: valueColor),
                  ),
                )
              : pw.Text(value, style: pw.TextStyle(color: valueColor)),
        ],
      ),
    );
  }

  pw.Widget tableHeaderCell({
    required bool isArabic,
    required pw.Font arabicFont,
    required String text,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        isArabic ? PdfArabicHelper.text(text) : text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          font: isArabic ? arabicFont : null,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget tableValueCell({
    required bool isArabic,
    required pw.Font arabicFont,
    required String text,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(font: isArabic ? arabicFont : null),
      ),
    );
  }

  Future<void> generatePdf({
    required BuildContext context,
    required String customer,
    required dynamic balance,
    required List<dynamic> transactions,
  }) async {
    try {
      final shop = await ShopService().getShop();
      final shopName = shop['name']?.toString() ?? '';
      final phone = shop['phone']?.toString() ?? '';
      final address = shop['address']
          .toString()
          .replaceAll('\r\n', ', ')
          .replaceAll('\n', ', ');

      final city = shop['city']?.toString() ?? '';
      final currency = shop['currency'];
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      final l10n = context.l10n;
      final logoBytes = await rootBundle.load(
        'assets/images/bashsoft_logo.png',
      );
      final arabicFontData = await rootBundle.load(
        'assets/fonts/NotoNaskhArabic-Regular.ttf',
      );

      final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
      final arabicFont = pw.Font.ttf(arabicFontData);

      double totalPurchases = 0;
      double totalPayments = 0;

      final balanceAmount = double.tryParse(balance.toString()) ?? 0;

      final formattedBalance = PdfArabicHelper.display(
        PdfFormatters.currency(balanceAmount, currency, isArabic: isArabic),
        isArabic,
      );

      for (final item in transactions) {
        final amount = double.tryParse(item['amount'].toString()) ?? 0;

        if (item['type'] == 'purchase') {
          totalPurchases += amount;
        } else {
          totalPayments += amount;
        }
      }

      final pdf = pw.Document();
      final statementNumber = 'ST-${DateTime.now().millisecondsSinceEpoch}';
      final customerWidget = isArabic
          ? PdfArabicHelper.rtl(
              child: pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: PdfArabicHelper.text('${l10n.customer}: '),
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.TextSpan(
                      text: customer,
                      style: pw.TextStyle(font: arabicFont),
                    ),
                  ],
                ),
              ),
            )
          : pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: '${l10n.customer}: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.TextSpan(text: customer),
                ],
              ),
            );

      final statementWidget = pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: pw.BoxDecoration(
          color: PdfColors.blue100,
          border: pw.Border.all(color: PdfColors.blue700),
        ),
        child: isArabic
            ? PdfArabicHelper.rtl(
                child: pw.Text(
                  PdfArabicHelper.text(
                    '${l10n.statementNumber}: $statementNumber',
                  ),
                  style: pw.TextStyle(
                    font: arabicFont,
                    color: PdfColors.blue900,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              )
            : pw.Text(
                '${l10n.statementNumber}: $statementNumber',
                style: pw.TextStyle(
                  color: PdfColors.blue900,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
      );

      pdf.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            theme: pw.ThemeData.withFont(base: arabicFont),
          ),

          header: (context) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 5),

              child: pw.Column(
                children: [
                  pw.Image(
                    logoImage,
                    width: 140,
                    height: 60,
                    fit: pw.BoxFit.contain,
                  ),

                  pw.SizedBox(height: 10),

                  pw.Text(
                    shopName,
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),

                  pw.Text('$phone | $city | $address'),
                  pdfLabel(
                    isArabic: isArabic,
                    arabicFont: arabicFont,
                    text: '${l10n.currency}: $currency',
                  ),
                  pw.Divider(),
                ],
              ),
            );
          },

          footer: (context) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(top: 10),

              child: pw.Column(
                children: [
                  pw.Divider(),

                  pdfLabel(
                    isArabic: isArabic,
                    arabicFont: arabicFont,
                    text: '${l10n.generatedByBashDafter} | $shopName',
                    color: PdfColors.grey,
                  ),

                  pdfLabel(
                    isArabic: isArabic,
                    arabicFont: arabicFont,
                    text: l10n.pageOf(context.pageNumber, context.pagesCount),
                    color: PdfColors.grey,
                  ),
                ],
              ),
            );
          },

          build: (context) {
            return [
              pw.Center(
                child: pdfLabel(
                  isArabic: isArabic,
                  arabicFont: arabicFont,
                  text: l10n.customerStatement,
                  bold: true,
                  fontSize: 18,
                ),
              ),

              pw.SizedBox(height: 30),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

                children: isArabic
                    ? [statementWidget, customerWidget]
                    : [customerWidget, statementWidget],
              ),

              pw.SizedBox(height: 20),

              isArabic
                  ? pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: PdfArabicHelper.rtl(
                        child: pw.RichText(
                          text: pw.TextSpan(
                            children: [
                              pw.TextSpan(
                                text: PdfArabicHelper.text(
                                  '${l10n.generatedDate}: ',
                                ),
                                style: pw.TextStyle(
                                  font: arabicFont,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),

                              pw.TextSpan(
                                text: PdfArabicHelper.display(
                                  PdfFormatters.date(
                                    DateTime.now(),
                                    isArabic: true,
                                  ),
                                  true,
                                ),
                                style: pw.TextStyle(font: arabicFont),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : pw.RichText(
                      text: pw.TextSpan(
                        children: [
                          pw.TextSpan(
                            text: '${l10n.generatedDate}: ',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),

                          pw.TextSpan(text: PdfFormatters.date(DateTime.now())),
                        ],
                      ),
                    ),

              pw.SizedBox(height: 10),

              transactions.isEmpty
                  ? pw.Container(
                      padding: const pw.EdgeInsets.all(10),
                      child: pdfLabel(
                        isArabic: isArabic,
                        arabicFont: arabicFont,
                        text: l10n.customerStatementNoTransactions,
                        color: PdfColors.grey700,
                      ),
                    )
                  : pw.Directionality(
                      textDirection: isArabic
                          ? pw.TextDirection.rtl
                          : pw.TextDirection.ltr,
                      child: pw.Table(
                        border: pw.TableBorder.all(color: PdfColors.grey400),

                        columnWidths: {
                          0: const pw.FlexColumnWidth(2),
                          1: const pw.FlexColumnWidth(2),
                          2: const pw.FlexColumnWidth(2),
                        },

                        children: [
                          // HEADER
                          pw.TableRow(
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.blue200,
                            ),

                            children: isArabic
                                ? [
                                    tableHeaderCell(
                                      isArabic: isArabic,
                                      arabicFont: arabicFont,
                                      text: l10n.transactionAmount,
                                    ),
                                    tableHeaderCell(
                                      isArabic: isArabic,
                                      arabicFont: arabicFont,
                                      text: l10n.transactionType,
                                    ),
                                    tableHeaderCell(
                                      isArabic: isArabic,
                                      arabicFont: arabicFont,
                                      text: l10n.transactionDate,
                                    ),
                                  ]
                                : [
                                    tableHeaderCell(
                                      isArabic: isArabic,
                                      arabicFont: arabicFont,
                                      text: l10n.transactionDate,
                                    ),
                                    tableHeaderCell(
                                      isArabic: isArabic,
                                      arabicFont: arabicFont,
                                      text: l10n.transactionType,
                                    ),
                                    tableHeaderCell(
                                      isArabic: isArabic,
                                      arabicFont: arabicFont,
                                      text: l10n.transactionAmount,
                                    ),
                                  ],
                          ),

                          ...transactions.map((item) {
                            final transactionType = item['type'] == 'purchase'
                                ? l10n.purchase
                                : l10n.payment;

                            return pw.TableRow(
                              children: isArabic
                                  ? [
                                      tableValueCell(
                                        isArabic: isArabic,
                                        arabicFont: arabicFont,
                                        text: PdfArabicHelper.display(
                                          PdfFormatters.currency(
                                            double.tryParse(
                                                  item['amount'].toString(),
                                                ) ??
                                                0,
                                            currency,
                                            isArabic: isArabic,
                                          ),
                                          isArabic,
                                        ),
                                      ),

                                      tableValueCell(
                                        isArabic: isArabic,
                                        arabicFont: arabicFont,
                                        text: PdfArabicHelper.text(
                                          transactionType,
                                        ),
                                      ),

                                      tableValueCell(
                                        isArabic: isArabic,
                                        arabicFont: arabicFont,
                                        text: PdfArabicHelper.display(
                                          PdfFormatters.date(
                                            DateTime.parse(
                                              item['date'].toString(),
                                            ),
                                            isArabic: isArabic,
                                          ),
                                          isArabic,
                                        ),
                                      ),
                                    ]
                                  : [
                                      tableValueCell(
                                        isArabic: isArabic,
                                        arabicFont: arabicFont,
                                        text: PdfArabicHelper.display(
                                          PdfFormatters.date(
                                            DateTime.parse(
                                              item['date'].toString(),
                                            ),
                                            isArabic: isArabic,
                                          ),
                                          isArabic,
                                        ),
                                      ),

                                      tableValueCell(
                                        isArabic: isArabic,
                                        arabicFont: arabicFont,
                                        text: transactionType,
                                      ),

                                      tableValueCell(
                                        isArabic: isArabic,
                                        arabicFont: arabicFont,
                                        text: PdfArabicHelper.display(
                                          PdfFormatters.currency(
                                            double.tryParse(
                                                  item['amount'].toString(),
                                                ) ??
                                                0,
                                            currency,
                                            isArabic: isArabic,
                                          ),
                                          isArabic,
                                        ),
                                      ),
                                    ],
                            );
                          }),
                        ],
                      ),
                    ),

              pw.SizedBox(height: 10),
              // pw.Text('Total Transactions: ${transactions.length}'),

              isArabic
                  ? pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: PdfArabicHelper.rtl(
                        child: pw.RichText(
                          text: pw.TextSpan(
                            children: [
                              pw.TextSpan(
                                text: PdfArabicHelper.text(
                                  '${l10n.totalTransactions}: ',
                                ),
                                style: pw.TextStyle(
                                  font: arabicFont,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),

                              pw.TextSpan(
                                text: PdfFormatters.number(
                                  transactions.length,
                                  isArabic: true,
                                ),
                                style: pw.TextStyle(font: arabicFont),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : pw.RichText(
                      text: pw.TextSpan(
                        children: [
                          pw.TextSpan(
                            text: '${l10n.totalTransactions}: ',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),

                          pw.TextSpan(
                            text: PdfFormatters.number(transactions.length),
                          ),
                        ],
                      ),
                    ),

              pw.SizedBox(height: 10),

              pw.Container(
                padding: const pw.EdgeInsets.all(6),

                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  color: PdfColors.grey100,
                ),

                child: pw.Column(
                  crossAxisAlignment: isArabic
                      ? pw.CrossAxisAlignment.end
                      : pw.CrossAxisAlignment.start,

                  children: [
                    summaryRow(
                      isArabic: isArabic,
                      arabicFont: arabicFont,
                      label: l10n.totalPurchases,
                      value: PdfArabicHelper.display(
                        PdfFormatters.currency(
                          totalPurchases,
                          currency,
                          isArabic: isArabic,
                        ),
                        isArabic,
                      ),
                    ),

                    pw.SizedBox(height: 4),

                    summaryRow(
                      isArabic: isArabic,
                      arabicFont: arabicFont,
                      label: l10n.totalPayments,
                      value: PdfArabicHelper.display(
                        PdfFormatters.currency(
                          totalPayments,
                          currency,
                          isArabic: isArabic,
                        ),
                        isArabic,
                      ),
                    ),

                    pw.Divider(),

                    summaryRow(
                      isArabic: isArabic,
                      arabicFont: arabicFont,
                      label: l10n.balance,
                      value: formattedBalance,
                      valueColor: balanceAmount > 0
                          ? PdfColors.red800
                          : PdfColors.green800,
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 30),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pdfLabel(
                        isArabic: isArabic,
                        arabicFont: arabicFont,
                        text: l10n.preparedBy,
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text('________________'),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pdfLabel(
                        isArabic: isArabic,
                        arabicFont: arabicFont,
                        text: l10n.authorizedSignature,
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text('________________'),
                    ],
                  ),
                ],
              ),
            ];
          },
        ),
      );

      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    } catch (e) {
      throw Exception('Failed to generate customer statement PDF: $e');
    }
  }
}
