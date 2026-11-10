import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
      appBar: AppBar(title: const Text('Scan Barcode')),

      body: MobileScanner(
        onDetect: (capture) {
          if (scanned) {
            return;
          }

          final barcode = capture.barcodes.first.rawValue;

          if (barcode == null) {
            return;
          }

          scanned = true;
          Navigator.pop(context, barcode);
        },
      ),
    );
  }
}
