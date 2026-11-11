import 'package:flutter/material.dart';

import '../services/category_service.dart';
import '../services/product_service.dart';
import '../services/unit_service.dart';

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
        const SnackBar(content: Text('Failed to load dropdown data')),
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
      ).showSnackBar(const SnackBar(content: Text('Product name is required')));

      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));

      return;
    }

    if (selectedUnit == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please select a unit')));

      return;
    }

    final costPrice = double.tryParse(costPriceController.text.trim());

    if (costPrice == null || costPrice < 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid cost price')));

      return;
    }

    final sellingPrice = double.tryParse(sellingPriceController.text.trim());

    if (sellingPrice == null || sellingPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid selling price')),
      );

      return;
    }

    final minimumStock = double.tryParse(minimumStockController.text.trim());

    if (minimumStock == null || minimumStock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid minimum stock')),
      );

      return;
    }

    if (hasExpiry && expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an expiry date')),
      );

      return;
    }

    if (sellingPrice < costPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selling price cannot be less than cost price'),
        ),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await ProductService().createProduct(
        shopId: 1,
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
        const SnackBar(content: Text('Product added successfully')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save product')));

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
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Product Name'),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: barcodeController,
            keyboardType: TextInputType.number,

            decoration: InputDecoration(
              labelText: 'Barcode',

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
            value: selectedCategory,

            items: categories.map((item) {
              return DropdownMenuItem<int>(
                value: item['id'],
                child: Text(item['name']),
              );
            }).toList(),

            decoration: const InputDecoration(labelText: 'Category'),

            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<int>(
            value: selectedUnit,

            items: units.map((item) {
              return DropdownMenuItem<int>(
                value: item['id'],

                child: Text(item['name']),
              );
            }).toList(),

            decoration: const InputDecoration(labelText: 'Unit'),

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
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Cost Price'),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: sellingPriceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Selling Price'),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: minimumStockController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Minimum Stock'),
          ),

          SwitchListTile(
            title: const Text('Has Expiry Date'),
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
                    ? 'Select Expiry Date'
                    : expiryDate!.toString().split(' ').first,
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
            decoration: const InputDecoration(labelText: 'Description'),
            textInputAction: TextInputAction.done,

            onSubmitted: (_) {
              if (!isSaving) {
                saveProduct();
              }
            },
          ),

          const SizedBox(height: 20),

          ElevatedButton(
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
                : const Text('Save Product'),
          ),
        ],
      ),
    );
  }
}
