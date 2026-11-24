class TopSellingProductModel {
  final int id;

  final int rank;

  final String name;

  final num totalSold;

  final num currentStock;

  TopSellingProductModel({
    required this.id,
    required this.rank,
    required this.name,
    required this.totalSold,
    required this.currentStock,
  });

  factory TopSellingProductModel.fromJson(Map<String, dynamic> json) {
    return TopSellingProductModel(
      id: json['id'] ?? 0,

      rank: json['rank'] ?? 0,

      name: json['name'] ?? '',

      totalSold: json['total_sold'] ?? 0,

      currentStock: json['current_stock'] ?? 0,
    );
  }
}
