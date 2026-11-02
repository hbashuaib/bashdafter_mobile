import 'package:flutter/material.dart';

import '../services/shop_service.dart';

class ShopProfileScreen extends StatefulWidget {
  const ShopProfileScreen({super.key});

  @override
  State<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen> {
  Map<String, dynamic>? shop;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final currencyController = TextEditingController();
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    loadShop();
  }

  Future<void> loadShop() async {
    final data = await ShopService().getShop();
    shop = data;
    nameController.text = data['name'];
    phoneController.text = data['phone'];
    addressController.text = data['address'];
    cityController.text = data['city'];
    currencyController.text = data['currency'];
    isActive = data['is_active'];
    setState(() {});
  }

  Future<void> saveShop() async {
    await ShopService().updateShop(
      id: shop!['id'],
      name: nameController.text,
      phone: phoneController.text,
      address: addressController.text,
      city: cityController.text,
      currency: currencyController.text,
      isActive: isActive,
      owner: shop!['owner'],
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Shop profile updated')));
  }

  @override
  Widget build(BuildContext context) {
    if (shop == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Shop Profile')),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Shop Name'),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'Phone'),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: addressController,
            decoration: const InputDecoration(labelText: 'Address'),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: cityController,
            decoration: const InputDecoration(labelText: 'City'),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: currencyController,
            decoration: const InputDecoration(labelText: 'Currency'),
          ),

          const SizedBox(height: 15),

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
            onPressed: saveShop,
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
