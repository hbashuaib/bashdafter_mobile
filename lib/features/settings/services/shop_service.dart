import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class ShopService {
  Future<Map<String, dynamic>> getShop() async {
    final token = await TokenStorage.getAccessToken();

    final response = await Dio().get(
      '${ApiConstants.baseUrl}/shops/',

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data.first;
  }

  Future<void> updateShop({
    required int id,
    required String name,
    required String phone,
    required String address,
    required String city,
    required String currency,
    required bool isActive,
    required int owner,
  }) async {
    final token = await TokenStorage.getAccessToken();

    final response = await Dio().put(
      '${ApiConstants.baseUrl}/shops/$id/',

      data: {
        'name': name,
        'phone': phone,
        'address': address,
        'city': city,
        'currency': currency,
        'is_active': isActive,
        'owner': owner,
      },

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    debugPrint(response.data.toString());
  }
}
