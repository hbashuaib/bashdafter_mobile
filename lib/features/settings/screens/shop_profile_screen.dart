import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/shop_service.dart';
import '../models/shop_model.dart';
import '../../../core/localization/localization_extension.dart';
import '../../../core/providers/shop_provider.dart';
import '../../../core/constants/supported_currencies.dart';

class ShopProfileScreen extends StatefulWidget {
  const ShopProfileScreen({super.key});

  @override
  State<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen> {
  ShopModel? shop;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  String selectedCurrency = 'YER';
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

      nameController.text = data.name;
      phoneController.text = data.phone;
      addressController.text = data.address;
      cityController.text = data.city;
      selectedCurrency = data.currency;
      context.read<ShopProvider>().setShop(data.toJson());

      setState(() {
        shop = data;
        isActive = data.isActive;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToLoadShopProfile)),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveShop() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.shopNameRequired)));

      return;
    }

    if (phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.phoneRequired)));

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await ShopService().updateShop(
        id: shop!.id,
        name: nameController.text,
        phone: phoneController.text,
        address: addressController.text,
        city: cityController.text,
        currency: selectedCurrency,
        isActive: isActive,
        owner: shop!.owner,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.shopProfileUpdated)));
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.failedToUpdateShopProfile)),
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
        appBar: AppBar(title: Text(context.l10n.shopProfile)),

        body: Center(child: Text(context.l10n.noShopProfileFound)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.shopProfile)),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),

        children: [
          TextField(
            controller: nameController,
            textDirection: Directionality.of(context),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: context.l10n.shopName),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: phoneController,
            textDirection: Directionality.of(context),
            keyboardType: TextInputType.phone,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: context.l10n.phoneNumber),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: addressController,
            textDirection: Directionality.of(context),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: context.l10n.address),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: cityController,
            textDirection: Directionality.of(context),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: context.l10n.city),
          ),

          const SizedBox(height: 15),

          DropdownButtonFormField<String>(
            initialValue: selectedCurrency,
            decoration: InputDecoration(labelText: context.l10n.currency),

            items: SupportedCurrencies.all.map((currency) {
              return DropdownMenuItem<String>(
                value: currency,
                child: Text(currency),
              );
            }).toList(),

            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedCurrency = value;
                });
              }
            },
          ),

          const SizedBox(height: 15),

          SwitchListTile(
            title: Text(context.l10n.active),
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
                  : Text(context.l10n.saveChanges),
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

    super.dispose();
  }
}
