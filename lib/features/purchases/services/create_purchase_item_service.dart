import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/storage/token_storage.dart';

class CreatePurchaseItemService {
  Future<void> createItem({
    required int purchaseId,
    required int productId,
    required String itemName,
    required String quantity,
    required String unitPrice,
  }) async {
    final token = await TokenStorage.getAccessToken();

    await Dio().post(
      '${ApiConstants.baseUrl}/purchase-items/',

      data: {
        'purchase': purchaseId,
        'product': productId,
        'item_name': itemName,
        'quantity': quantity,
        'unit_price': unitPrice,
      },

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
