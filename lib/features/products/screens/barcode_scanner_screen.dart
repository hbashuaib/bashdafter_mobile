import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/localization/localization_extension.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.scanBarcode)),

      body: MobileScanner(
        onDetect: (capture) {
          if (scanned) {
            return;
          }

          final barcode = capture.barcodes.first.rawValue;

          if (barcode == null) {
            return;
          }

          setState(() {
            scanned = true;
          });

          if (!mounted) return;

          Navigator.pop(context, barcode);
        },
      ),
    );
  }
}
