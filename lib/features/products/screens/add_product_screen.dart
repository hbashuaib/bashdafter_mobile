import 'package:flutter/material.dart';

import '../services/category_service.dart';
import '../services/product_service.dart';
import '../services/unit_service.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/localization/app_formatters.dart';

import 'barcode_scanner_screen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final barcodeController = TextEditingController();
  final descriptionController = TextEditingController();
  final costPriceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final minimumStockController = TextEditingController();

  List<dynamic> categories = [];
  List<dynamic> units = [];
  int? selectedCategory;
  int? selectedUnit;
  DateTime? expiryDate;
  bool isLoading = true;
  bool isSaving = false;
  bool hasExpiry = false;

  @override
  void initState() {
    super.initState();
    loadDropdowns();
  }

  Future<void> loadDropdowns() async {
    try {
      final categoryData = await CategoryService().getCategories();
      final unitData = await UnitService().getUnits();

      if (!mounted) return;

      setState(() {
        categories = categoryData;
        units = unitData;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadDropdownData)),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveProduct() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.productNameRequired)));

      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.pleaseSelectCategory)),
      );

      return;
    }

    if (selectedUnit == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.pleaseSelectUnit)));

      return;
    }

    final costPrice = double.tryParse(costPriceController.text.trim());

    if (costPrice == null || costPrice < 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.enterValidCostPrice)));

      return;
    }

    final sellingPrice = double.tryParse(sellingPriceController.text.trim());

    if (sellingPrice == null || sellingPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.enterValidSellingPrice)),
      );

      return;
    }

    final minimumStock = double.tryParse(minimumStockController.text.trim());

    if (minimumStock == null || minimumStock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.enterValidMinimumStock)),
      );

      return;
    }

    if (hasExpiry && expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.pleaseSelectExpiryDate)),
      );

      return;
    }

    if (sellingPrice < costPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.sellingPriceCannotBeLessThanCostPrice),
        ),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await ProductService().createProduct(
        categoryId: selectedCategory!,
        unitId: selectedUnit!,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        costPrice: costPriceController.text.trim(),
        sellingPrice: sellingPriceController.text.trim(),
        minimumStock: minimumStockController.text.trim(),
        barcode: barcodeController.text.trim().isEmpty
            ? null
            : barcodeController.text.trim(),
        isActive: true,
        hasExpiry: hasExpiry,
        expiryDate: expiryDate?.toIso8601String().split('T').first,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.productAddedSuccessfully)),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.failedToSaveProduct)));

      debugPrint(e.toString());
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
    nameController.dispose();
    barcodeController.dispose();
    descriptionController.dispose();
    costPriceController.dispose();
    sellingPriceController.dispose();
    minimumStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.addProduct)),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: context.l10n.productName),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: barcodeController,
            keyboardType: TextInputType.number,
            autocorrect: false,
            enableSuggestions: false,

            decoration: InputDecoration(
              labelText: context.l10n.barcodeLabel,
              prefixIcon: const Icon(Icons.qr_code),
              suffixIcon: IconButton(
                icon: const Icon(Icons.camera_alt),

                onPressed: () async {
                  final barcode = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BarcodeScannerScreen(),
                    ),
                  );

                  if (barcode != null) {
                    barcodeController.text = barcode.toString();
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<int>(
            initialValue: selectedCategory,

            items: categories.map((item) {
              return DropdownMenuItem<int>(
                value: item['id'],
                child: Text(item['name']),
              );
            }).toList(),

            decoration: InputDecoration(labelText: context.l10n.category),

            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<int>(
            initialValue: selectedUnit,

            items: units.map((item) {
              return DropdownMenuItem<int>(
                value: item['id'],

                child: Text(item['name']),
              );
            }).toList(),

            decoration: InputDecoration(labelText: context.l10n.unit),

            onChanged: (value) {
              setState(() {
                selectedUnit = value;
              });
            },
          ),

          const SizedBox(height: 12),

          TextField(
            controller: costPriceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: context.l10n.costPrice),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: sellingPriceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: context.l10n.sellingPrice),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: minimumStockController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: context.l10n.minimumStock),
          ),

          SwitchListTile(
            title: Text(context.l10n.hasExpiryDate),
            value: hasExpiry,

            onChanged: (value) {
              setState(() {
                hasExpiry = value;

                if (!value) {
                  expiryDate = null;
                }
              });
            },
          ),

          if (hasExpiry)
            ListTile(
              leading: const Icon(Icons.calendar_month),

              title: Text(
                expiryDate == null
                    ? context.l10n.selectExpiryDate
                    : AppFormatters.date(context, expiryDate!),
              ),

              onTap: () async {
                final selected = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  initialDate: expiryDate ?? DateTime.now(),
                );

                if (selected != null) {
                  setState(() {
                    expiryDate = selected;
                  });
                }
              },
            ),

          const SizedBox(height: 12),

          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: InputDecoration(labelText: context.l10n.description),
            textInputAction: TextInputAction.done,

            onSubmitted: (_) {
              if (!isSaving) {
                saveProduct();
              }
            },
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: isSaving ? null : saveProduct,

              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(context.l10n.saveProduct),
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
