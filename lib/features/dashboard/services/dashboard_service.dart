import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class DashboardService {

  Future<Map<String, dynamic>> getDashboard() async {

    final token = await TokenStorage.getAccessToken();
    
    final response = await Dio().get('${ApiConstants.baseUrl}/dashboard/',
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
        },
      ),
    );

    return response.data;
  }
}