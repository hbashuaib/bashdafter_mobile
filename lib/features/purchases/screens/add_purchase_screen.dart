import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/create_purchase_service.dart';
import '../services/create_purchase_item_service.dart';
import '../../products/services/product_service.dart';
import '../../products/services/barcode_lookup_service.dart';
import '../../products/screens/barcode_scanner_screen.dart';
import '../../products/models/product_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';
import '../../../core/providers/shop_provider.dart';
import '../../../core/localization/app_localized_name.dart';

class AddPurchaseScreen extends StatefulWidget {
  final int customerId;

  const AddPurchaseScreen({super.key, required this.customerId});

  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  final quantityController = TextEditingController();
  final unitPriceController = TextEditingController();
  final notesController = TextEditingController();
  final FocusNode quantityFocusNode = FocusNode();
  bool isSaving = false;
  List<Map<String, dynamic>> purchaseItems = [];
  List<ProductModel> products = [];
  ProductModel? selectedProduct;

  @override
  void initState() {
    super.initState();
    loadProducts();
    quantityController.text = '1';
  }

  @override
  void dispose() {
    quantityFocusNode.dispose();

    quantityController.dispose();
    unitPriceController.dispose();
    notesController.dispose();

    super.dispose();
  }

  Future<void> loadProducts() async {
    try {
      final data = await ProductService().getProducts();

      if (!mounted) return;

      setState(() {
        products = data;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadProducts)),
      );
    }
  }

  void addItem() {
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

    final unitPrice = double.tryParse(unitPriceController.text.trim());

    if (unitPrice == null || unitPrice <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.enterValidUnitPrice)));

      return;
    }

    final exists = purchaseItems.any(
      (item) => item['product_id'] == selectedProduct!.id,
    );

    if (exists) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.productAlreadyAdded)));

      return;
    }

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

    purchaseItems.add({
      'product_id': selectedProduct!.id,
      'item_name': selectedProduct!.name,
      'quantity': quantityController.text.trim(),
      'unit_price': unitPriceController.text.trim(),
    });

    setState(() {
      quantityController.text = '1';
      unitPriceController.text = '';
      selectedProduct = null;
    });

    FocusScope.of(context).unfocus();
  }

  Future<void> savePurchase() async {
    if (purchaseItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.addAtLeastOneItem)));

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final purchaseId = await CreatePurchaseService().createPurchase(
        customerId: widget.customerId,
        notes: notesController.text.trim(),
      );

      for (final item in purchaseItems) {
        await CreatePurchaseItemService().createItem(
          purchaseId: purchaseId,
          productId: item['product_id'],
          itemName: item['item_name'],
          quantity: item['quantity'],
          unitPrice: item['unit_price'],
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.purchaseSavedSuccessfully)),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToSavePurchase)),
      );

      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  double get totalAmount {
    double total = 0;

    for (final item in purchaseItems) {
      final quantity = double.tryParse(item['quantity'].toString()) ?? 0;
      final unitPrice = double.tryParse(item['unit_price'].toString()) ?? 0;
      total += quantity * unitPrice;
    }

    return total;
  }

  double get lineTotal {
    final quantity = double.tryParse(quantityController.text) ?? 0;
    final price = double.tryParse(unitPriceController.text) ?? 0;
    return quantity * price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.addPurchase)),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                icon: const Icon(Icons.qr_code_scanner),
                label: Text(context.l10n.scanProductBarcode),

                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  final l10n = context.l10n;

                  final isArabic =
                      Localizations.localeOf(context).languageCode == 'ar';

                  final barcode = await navigator.push(
                    MaterialPageRoute(
                      builder: (_) => const BarcodeScannerScreen(),
                    ),
                  );

                  if (!mounted || barcode == null) {
                    return;
                  }

                  try {
                    final product = await BarcodeLookupService()
                        .findProductByBarcode(barcode.toString());

                    final selected = products.firstWhere(
                      (p) => p.id == product.id,
                      orElse: () => product,
                    );

                    if (!mounted) {
                      return;
                    }

                    setState(() {
                      selectedProduct = selected;
                      quantityController.text = '1';

                      unitPriceController.text = selected.sellingPrice;
                    });

                    quantityFocusNode.requestFocus();

                    if (!mounted) {
                      return;
                    }

                    final localizedProductName =
                        AppLocalizedName.resolveByLanguage(
                          isArabic: isArabic,
                          name: product.name,
                          nameEn: product.nameEn,
                          nameAr: product.nameAr,
                        );

                    messenger.showSnackBar(
                      SnackBar(content: Text(localizedProductName)),
                    );
                  } catch (_) {
                    if (!mounted) {
                      return;
                    }

                    messenger.showSnackBar(
                      SnackBar(content: Text(l10n.productNotFound)),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<ProductModel>(
              initialValue: selectedProduct,
              decoration: InputDecoration(labelText: context.l10n.product),

              items: products.map((product) {
                return DropdownMenuItem(
                  value: product,

                  child: Text(
                    AppLocalizedName.resolve(
                      context: context,
                      name: product.name,
                      nameEn: product.nameEn,
                      nameAr: product.nameAr,
                    ),
                  ),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedProduct = value;
                  unitPriceController.text = value?.sellingPrice ?? '';
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              focusNode: quantityFocusNode,
              controller: quantityController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                addItem();
              },
              decoration: InputDecoration(labelText: context.l10n.quantity),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: unitPriceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.done,

              onChanged: (_) {
                setState(() {});
              },

              onSubmitted: (_) {
                addItem();
              },

              decoration: InputDecoration(labelText: context.l10n.unitPrice),
            ),

            const SizedBox(height: 15),

            Card(
              color: AppColors.cardTint(context, Colors.green.shade50),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(context.l10n.lineTotal),

                    Text(
                      AppFormatters.currency(
                        context,
                        lineTotal,
                        context.read<ShopProvider>().currency,
                      ),

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: addItem,
                icon: const Icon(Icons.add),
                label: Text(context.l10n.addItem),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              context.l10n.purchaseItems,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            if (purchaseItems.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      context.l10n.noItemsAddedYet,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              )
            else
              ...purchaseItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                final quantity =
                    double.tryParse(item['quantity'].toString()) ?? 0;

                final unitPrice =
                    double.tryParse(item['unit_price'].toString()) ?? 0;

                final total = quantity * unitPrice;

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),

                  child: ListTile(
                    title: Text(
                      item['item_name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${context.l10n.quantity}: ${AppFormatters.number(context, quantity)}',
                        ),
                        Text(
                          '${context.l10n.unitPrice}: '
                          '${AppFormatters.currency(context, unitPrice, context.read<ShopProvider>().currency)}',
                        ),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardTint(
                              context,
                              Colors.green.shade100,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            AppFormatters.currency(
                              context,
                              total,
                              context.read<ShopProvider>().currency,
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),

                          onPressed: () {
                            purchaseItems.removeAt(index);

                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),

            TextField(
              controller: notesController,
              decoration: InputDecoration(labelText: context.l10n.notes),
            ),

            const SizedBox(height: 15),

            Card(
              color: AppColors.cardTint(context, Colors.blue.shade50),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      context.l10n.purchaseTotal,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Text(
                      AppFormatters.currency(
                        context,
                        totalAmount,
                        context.read<ShopProvider>().currency,
                      ),

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: isSaving ? null : savePurchase,
                child: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(context.l10n.savePurchase),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
