import 'package:flutter/material.dart';

import '../services/category_service.dart';
import '../services/product_service.dart';
import '../services/unit_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final costPriceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final minimumStockController = TextEditingController();

  List<dynamic> categories = [];
  List<dynamic> units = [];
  int? selectedCategory;
  int? selectedUnit;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDropdowns();
  }

  Future<void> loadDropdowns() async {
    final categoryData = await CategoryService().getCategories();
    final unitData = await UnitService().getUnits();

    setState(() {
      categories = categoryData;
      units = unitData;
      isLoading = false;
    });
  }

  Future<void> saveProduct() async {
    await ProductService().createProduct(
      shopId: 1,
      categoryId: selectedCategory!,
      unitId: selectedUnit!,
      name: nameController.text,
      description: descriptionController.text,
      costPrice: costPriceController.text,
      sellingPrice: sellingPriceController.text,
      minimumStock: minimumStockController.text,
      barcode: null,
      isActive: true,
    );

    if (!mounted) return;

    Navigator.pop(context, true);
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
            decoration: const InputDecoration(labelText: 'Product Name'),
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

            decoration: const InputDecoration(labelText: 'Cost Price'),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: sellingPriceController,
            decoration: const InputDecoration(labelText: 'Selling Price'),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: minimumStockController,
            decoration: const InputDecoration(labelText: 'Minimum Stock'),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Description'),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: saveProduct,
            child: const Text('Save Product'),
          ),
        ],
      ),
    );
  }
}
