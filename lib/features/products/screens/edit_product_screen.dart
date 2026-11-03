import 'package:flutter/material.dart';

import '../services/category_service.dart';
import '../services/product_service.dart';
import '../services/unit_service.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final costPriceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final minimumStockController = TextEditingController();

  List<dynamic> categories = [];
  List<dynamic> units = [];
  int? selectedCategory;
  int? selectedUnit;
  bool isActive = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.product['name'] ?? '';
    descriptionController.text = widget.product['description'] ?? '';
    costPriceController.text = widget.product['cost_price'] ?? '';
    sellingPriceController.text = widget.product['selling_price'] ?? '';
    minimumStockController.text = widget.product['minimum_stock'] ?? '';
    selectedCategory = widget.product['category'];
    selectedUnit = widget.product['unit'];
    isActive = widget.product['is_active'];
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

  Future<void> updateProduct() async {
    await ProductService().updateProduct(
      id: widget.product['id'],
      shopId: widget.product['shop'],
      categoryId: selectedCategory!,
      unitId: selectedUnit!,
      name: nameController.text,
      barcode: widget.product['barcode'],
      description: descriptionController.text,
      costPrice: costPriceController.text,
      sellingPrice: sellingPriceController.text,
      minimumStock: minimumStockController.text,
      isActive: isActive,
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
      appBar: AppBar(title: const Text('Edit Product')),

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
            decoration: const InputDecoration(labelText: 'Category'),

            items: categories.map((item) {
              return DropdownMenuItem<int>(
                value: item['id'],
                child: Text(item['name']),
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<int>(
            value: selectedUnit,
            decoration: const InputDecoration(labelText: 'Unit'),

            items: units.map((item) {
              return DropdownMenuItem<int>(
                value: item['id'],
                child: Text(item['name']),
              );
            }).toList(),

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

          const SizedBox(height: 12),

          SwitchListTile(
            title: const Text('Active'),
            value: isActive,

            onChanged: (value) {
              setState(() {
                isActive = value;
              });
            },
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: updateProduct,
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
