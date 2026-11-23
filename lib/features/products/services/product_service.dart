import 'package:dio/dio.dart';

import '../models/product_model.dart';

import '../../../core/api/api_client.dart';

class ProductService {
  Future<List<ProductModel>> getProducts() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/products/');

      return (response.data as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected product loading error');
    }
  }

  Future<void> createProduct({
    required int categoryId,
    required int unitId,
    required String name,
    String? nameEn,
    String? nameAr,
    String? barcode,
    String? description,
    required String costPrice,
    required String sellingPrice,
    required String minimumStock,
    required bool isActive,
    required bool hasExpiry,
    String? expiryDate,
  }) async {
    final dio = await ApiClient.instance;

    try {
      await dio.post(
        '/products/',

        data: {
          'name': name.trim(),
          'name_en': nameEn?.trim() ?? '',
          'name_ar': nameAr?.trim() ?? '',

          'barcode': (barcode == null || barcode.trim().isEmpty)
              ? null
              : barcode.trim(),

          'description': description?.trim(),
          'cost_price': costPrice.trim(),
          'selling_price': sellingPrice.trim(),
          'minimum_stock': minimumStock.trim(),
          'has_expiry': hasExpiry,
          'expiry_date': expiryDate,
          'is_active': isActive,
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
    required int categoryId,
    required int unitId,
    required String name,
    String? nameEn,
    String? nameAr,
    String? barcode,
    String? description,
    required String costPrice,
    required String sellingPrice,
    required String minimumStock,
    required bool isActive,
    required bool hasExpiry,
    String? expiryDate,
  }) async {
    final dio = await ApiClient.instance;

    try {
      await dio.put(
        '/products/$id/',

        data: {
          'name': name.trim(),
          'name_en': nameEn?.trim() ?? '',
          'name_ar': nameAr?.trim() ?? '',

          'barcode': (barcode == null || barcode.trim().isEmpty)
              ? null
              : barcode.trim(),

          'description': description?.trim(),
          'cost_price': costPrice.trim(),
          'selling_price': sellingPrice.trim(),
          'minimum_stock': minimumStock.trim(),
          'has_expiry': hasExpiry,
          'expiry_date': expiryDate,
          'is_active': isActive,
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
