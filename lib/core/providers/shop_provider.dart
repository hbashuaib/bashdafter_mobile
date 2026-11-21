import 'package:flutter/material.dart';

class ShopProvider extends ChangeNotifier {
  Map<String, dynamic>? _shop;
  Map<String, dynamic>? get shop => _shop;
  String get currency => _shop?['currency']?.toString() ?? 'YER';

  void setShop(Map<String, dynamic> shop) {
    _shop = shop;
    notifyListeners();
  }

  void updateCurrency(String currency) {
    if (_shop == null) return;
    _shop!['currency'] = currency;
    notifyListeners();
  }

  void clear() {
    _shop = null;
    notifyListeners();
  }
}
