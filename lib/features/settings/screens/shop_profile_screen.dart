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
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadShop();
  }

  Future<void> loadShop() async {
    try {
      setState(() {
        isLoading = true;
      });

      final data = await ShopService().getShop();

      if (!mounted) return;

      nameController.text = data['name']?.toString() ?? '';
      phoneController.text = data['phone']?.toString() ?? '';
      addressController.text = data['address']?.toString() ?? '';
      cityController.text = data['city']?.toString() ?? '';
      currencyController.text = data['currency']?.toString() ?? '';

      setState(() {
        shop = data;
        isActive = data['is_active'] ?? true;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load shop profile')),
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveShop() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Shop name is required')));

      return;
    }

    if (phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Phone is required')));

      return;
    }

    if (currencyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Currency is required')));

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
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
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update shop profile')),
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
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (shop == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Shop Profile')),

        body: const Center(child: Text('No shop profile found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Shop Profile')),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),

        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Shop Name'),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
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
            textCapitalization: TextCapitalization.characters,
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

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: isSaving ? null : saveShop,

              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,

                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    currencyController.dispose();

    super.dispose();
  }
}
