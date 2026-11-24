import '../../products/models/product_model.dart';

class VoicePurchaseItem {
  final String productName;
  int quantity;
  List<ProductModel> candidateProducts;
  ProductModel? matchedProduct;

  VoicePurchaseItem({
    required this.productName,
    required this.quantity,
    this.matchedProduct,
    this.candidateProducts = const [],
  });
}
