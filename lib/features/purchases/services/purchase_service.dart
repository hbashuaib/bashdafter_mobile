import 'package:dio/dio.dart';

import '../models/purchase_model.dart';
import '../../../core/api/api_client.dart';

class PurchaseService {
  Future<List<PurchaseModel>> getPurchases() async {
    final dio = await ApiClient.instance;

    try {
      final response = await dio.get('/purchases/');

      return (response.data as List)
          .map((item) => PurchaseModel.fromJson(item))
          .toList();
    } on DioException {
      rethrow;
    } catch (_) {
      throw Exception('Unexpected purchase loading error');
    }
  }
}
