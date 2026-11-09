import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class ProductService {
  Future<List<dynamic>> getProducts() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/products/');

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
    final dio = await ApiClient.instance;

    try {
      await dio.post(
        '/products/',

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
    final dio = await ApiClient.instance;

    try {
      await dio.put(
        '/products/$id/',

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
      );
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected product update error');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final dio = await ApiClient.instance;

    try {
      await dio.delete('/products/$productId/');
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected product delete error');
    }
  }
}
