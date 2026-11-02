import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CustomerStatementPdfService {
  Future<void> generatePdf({
    required String customer,
    required dynamic balance,
    required List<dynamic> transactions,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,

        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,

            children: [
              pw.Text(
                'BashDafter',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),
              pw.Text('Customer Statement'),
              pw.SizedBox(height: 20),
              pw.Text('Customer: $customer'),
              pw.Text('Balance: $balance'),
              pw.SizedBox(height: 20),

              pw.Table.fromTextArray(
                headers: const ['Date', 'Type', 'Amount'],

                data: transactions.map((item) {
                  return [
                    item['date'].toString(),
                    item['type'].toString(),
                    item['amount'].toString(),
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
