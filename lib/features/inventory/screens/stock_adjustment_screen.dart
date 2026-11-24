import 'package:flutter/material.dart';

import '../../products/services/product_service.dart';
import '../../products/models/product_model.dart';
import '../services/stock_adjustment_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';

class StockAdjustmentScreen extends StatefulWidget {
  final ProductModel? product;

  const StockAdjustmentScreen({super.key, this.product});

  @override
  State<StockAdjustmentScreen> createState() => _StockAdjustmentScreenState();
}

class _StockAdjustmentScreenState extends State<StockAdjustmentScreen> {
  List<ProductModel> products = [];
  ProductModel? selectedProduct;
  String adjustmentType = 'IN';

  final quantityController = TextEditingController();
  final reasonController = TextEditingController();
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data = await ProductService().getProducts();

      if (!mounted) return;

      setState(() {
        products = data;
        isLoading = false;

        if (widget.product != null) {
          final matches = data.where((p) => p.id == widget.product!.id);

          if (matches.isNotEmpty) {
            selectedProduct = matches.first;
          }
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadProducts)),
      );
    }
  }

  Future<void> saveAdjustment() async {
    if (selectedProduct == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.pleaseSelectProduct)));

      return;
    }

    final quantity = double.tryParse(quantityController.text.trim());

    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.enterValidQuantity)));

      return;
    }

    if (reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.reasonRequired)));

      return;
    }

    if (adjustmentType == 'OUT' || adjustmentType == 'DAMAGE') {
      final currentStock = double.tryParse(selectedProduct!.currentStock) ?? 0;

      if (quantity > currentStock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${context.l10n.only} '
              '${AppFormatters.number(context, currentStock)} '
              '${context.l10n.availableInStock}',
            ),
          ),
        );

        return;
      }
    }

    setState(() {
      isSaving = true;
    });

    try {
      await StockAdjustmentService().createAdjustment(
        productId: selectedProduct!.id,
        adjustmentType: adjustmentType,
        quantity: quantityController.text,
        reason: reasonController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.stockAdjustmentSavedSuccessfully)),
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToSaveStockAdjustment)),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    quantityController.dispose();
    reasonController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStock = selectedProduct == null
        ? 0.0
        : double.tryParse(selectedProduct!.currentStock) ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.stockAdjustment)),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            if (widget.product == null)
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                ),
            DropdownButtonFormField<ProductModel>(
              initialValue: selectedProduct,
              decoration: InputDecoration(labelText: context.l10n.product),

              items: products.map((product) {
                return DropdownMenuItem(
                  value: product,
                  child: Text(
                    product.name.isEmpty
                        ? context.l10n.unknownProduct
                        : product.name,
                  ),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedProduct = value;
                });
              },
            ),

            if (widget.product != null)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.inventory_2),
                  title: Text(
                    selectedProduct == null
                        ? ''
                        : selectedProduct!.name.isEmpty
                        ? context.l10n.unknownProduct
                        : selectedProduct!.name,
                  ),
                  subtitle: Text(context.l10n.selectedFromBarcodeLookup),
                ),
              ),

            if (selectedProduct != null)
              Card(
                color: AppColors.cardTint(context, Colors.blue.shade50),

                child: ListTile(
                  leading: const Icon(Icons.inventory),
                  title: Text(context.l10n.currentStock),
                  subtitle: Text(
                    // currentStock.toStringAsFixed(0)
                    AppFormatters.number(context, currentStock),
                  ),
                ),
              ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              initialValue: adjustmentType,

              decoration: InputDecoration(
                labelText: context.l10n.adjustmentType,
              ),

              items: [
                DropdownMenuItem(
                  value: 'OPENING',

                  child: Text(context.l10n.openingStock),
                ),

                DropdownMenuItem(
                  value: 'IN',
                  child: Text(context.l10n.stockIn),
                ),
                DropdownMenuItem(
                  value: 'OUT',
                  child: Text(context.l10n.stockOut),
                ),
                DropdownMenuItem(
                  value: 'DAMAGE',
                  child: Text(context.l10n.damagedStock),
                ),

                DropdownMenuItem(
                  value: 'CORRECTION',

                  child: Text(context.l10n.correction),
                ),
              ],

              onChanged: (value) {
                setState(() {
                  adjustmentType = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: quantityController,
              textDirection: Directionality.of(context),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: context.l10n.quantity),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: reasonController,
              textDirection: Directionality.of(context),
              maxLines: 2,
              decoration: InputDecoration(labelText: context.l10n.reason),
              textInputAction: TextInputAction.done,

              onSubmitted: (_) {
                if (!isSaving) {
                  saveAdjustment();
                }
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isSaving ? null : saveAdjustment,
                child: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(context.l10n.saveAdjustment),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
