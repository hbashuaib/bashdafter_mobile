import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class ProductService {
  Future<List<dynamic>> getProducts() async {
    final token = await TokenStorage.getAccessToken();

    final response = await Dio().get(
      '${ApiConstants.baseUrl}/products/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }

  Future<void> createProduct({
    required int shopId,
    required int categoryId,
    required int unitId,
    required String name,
    String? barcode,
    String? description,
    required String costPrice,
    required String sellingPrice,
    required String minimumStock,
    required bool isActive,
  }) async {
    final token = await TokenStorage.getAccessToken();

    await Dio().post(
      '${ApiConstants.baseUrl}/products/',
      data: {
        'name': name,
        'barcode': barcode,
        'description': description,
        'cost_price': costPrice,
        'selling_price': sellingPrice,
        'minimum_stock': minimumStock,
        'has_expiry': false,
        'expiry_date': null,
        'is_active': isActive,
        'shop': shopId,
        'category': categoryId,
        'unit': unitId,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
