import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class CustomerStatementService {
  Future<Map<String, dynamic>> getStatement(int customerId) async {
    final token = await TokenStorage.getAccessToken();

    final response = await Dio().get(
      '${ApiConstants.baseUrl}/reports/customer-statement/$customerId/',

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data;
  }
}
