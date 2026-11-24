import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../products/screens/barcode_scanner_screen.dart';
import '../../products/services/barcode_lookup_service.dart';
import '../../products/models/product_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';
import '../../../core/localization/app_localized_name.dart';

import 'stock_adjustment_screen.dart';

class InventoryLookupScreen extends StatefulWidget {
  const InventoryLookupScreen({super.key});

  @override
  State<InventoryLookupScreen> createState() => _InventoryLookupScreenState();
}

class _InventoryLookupScreenState extends State<InventoryLookupScreen> {
  ProductModel? product;
  bool isLoading = false;

  Future<void> scanBarcode() async {
    final messenger = ScaffoldMessenger.of(context);
    final productNotFoundText = context.l10n.productNotFound;

    final barcode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()),
    );

    if (!mounted || barcode == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final productModel = await BarcodeLookupService().findProductByBarcode(
        barcode.toString(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        product = productModel;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        product = null;
        isLoading = false;
      });

      messenger.showSnackBar(SnackBar(content: Text(productNotFoundText)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStock = product == null
        ? 0.0
        : double.tryParse(product!.currentStock) ?? 0;

    final minimumStock = product == null
        ? 0.0
        : double.tryParse(product!.minimumStock) ?? 0;

    final sellingPrice = product == null
        ? 0.0
        : double.tryParse(product!.sellingPrice) ?? 0;

    final isLowStock = currentStock <= minimumStock;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.inventoryLookup)),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            ElevatedButton.icon(
              onPressed: isLoading ? null : scanBarcode,
              icon: const Icon(Icons.qr_code_scanner),
              label: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(context.l10n.scanProduct),
            ),

            const SizedBox(height: 20),

            if (isLoading)
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(context.l10n.searchingProduct),
                  ],
                ),
              ),

            if (product != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        AppLocalizedName.resolve(
                          context: context,
                          name: product!.name,
                          nameEn: product!.nameEn,
                          nameAr: product!.nameAr,
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        '${context.l10n.barcodeLabel}: ${product!.barcode ?? '-'}',
                      ),
                      Text(
                        '${context.l10n.stock}: '
                        '${AppFormatters.number(context, currentStock)}',
                      ),
                      Text(
                        '${context.l10n.minimumStock}: '
                        '${AppFormatters.number(context, minimumStock)}',
                      ),
                      Text(
                        '${context.l10n.sellingPrice}: '
                        '${AppFormatters.currency(context, sellingPrice, context.read<ShopProvider>().currency)}',
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: AppColors.cardTint(
                            context,
                            isLowStock
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                          ),
                        ),

                        child: Text(
                          isLowStock
                              ? context.l10n.lowStockStatus
                              : context.l10n.inStock,

                          style: TextStyle(
                            color: isLowStock ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.inventory),
                          label: Text(context.l10n.adjustStock),

                          onPressed: () async {
                            final messenger = ScaffoldMessenger.of(context);
                            final stockUpdatedText = context.l10n.stockUpdated;
                            final currentStockText = context.l10n.currentStock;

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    StockAdjustmentScreen(product: product),
                              ),
                            );

                            if (!mounted) {
                              return;
                            }

                            if (result == true && product != null) {
                              debugPrint(
                                'Current barcode: ${product?.barcode}',
                              );

                              try {
                                if (product?.barcode == null) {
                                  return;
                                }

                                final updatedProduct =
                                    await BarcodeLookupService()
                                        .findProductByBarcode(
                                          product!.barcode!,
                                        );

                                final updatedStock =
                                    double.tryParse(
                                      updatedProduct.currentStock,
                                    ) ??
                                    0;

                                if (!mounted) {
                                  return;
                                }

                                setState(() {
                                  product = updatedProduct;
                                });

                                messenger.showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      '$stockUpdatedText. '
                                      '$currentStockText: '
                                      '${updatedStock.toInt()}',
                                    ),
                                  ),
                                );
                              } catch (e) {
                                debugPrint('Refresh failed: $e');
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ],
        ),
      ),
    );
  }
}
