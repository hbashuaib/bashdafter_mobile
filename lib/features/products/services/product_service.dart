import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class ProductService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Future<List<dynamic>> getProducts() async {
    final token = await TokenStorage.getAccessToken();

    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/products/',

        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data;
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected product loading error');
    }
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

    try {
      await _dio.post(
        '${ApiConstants.baseUrl}/products/',

        data: {
          'name': name.trim(),

          'barcode': (barcode == null || barcode.trim().isEmpty)
              ? null
              : barcode.trim(),

          'description': description?.trim(),
          'cost_price': costPrice.trim(),
          'selling_price': sellingPrice.trim(),
          'minimum_stock': minimumStock.trim(),
          'has_expiry': false,
          'expiry_date': null,
          'is_active': isActive,
          'shop': shopId,
          'category': categoryId,
          'unit': unitId,
        },

        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected product creation error');
    }
  }

  Future<void> updateProduct({
    required int id,
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

    try {
      await _dio.put(
        '${ApiConstants.baseUrl}/products/$id/',

        data: {
          'name': name.trim(),

          'barcode': (barcode == null || barcode.trim().isEmpty)
              ? null
              : barcode.trim(),

          'description': description?.trim(),
          'cost_price': costPrice.trim(),
          'selling_price': sellingPrice.trim(),
          'minimum_stock': minimumStock.trim(),
          'has_expiry': false,
          'expiry_date': null,
          'is_active': isActive,
          'shop': shopId,
          'category': categoryId,
          'unit': unitId,
        },

        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected product update error');
    }
  }
}
