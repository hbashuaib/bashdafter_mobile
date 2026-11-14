class VoicePurchaseItem {
  final String productName;
  int quantity;
  List<dynamic> candidateProducts;

  Map<String, dynamic>? matchedProduct;

  VoicePurchaseItem({
    required this.productName,
    required this.quantity,
    this.matchedProduct,
    this.candidateProducts = const [],
  });
}
