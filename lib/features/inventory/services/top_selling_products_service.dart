import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class TopSellingProductsService {
  Future<List<dynamic>> getProducts() async {
    final token = await TokenStorage.getAccessToken();

    final response = await Dio().get(
      '${ApiConstants.baseUrl}/top-selling-products/',

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }
}
