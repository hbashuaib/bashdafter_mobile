class InventoryDashboardModel {
  final int totalProducts;

  final int lowStockProducts;

  final int expiringProducts;

  final int stockAdjustments;

  final int inventoryTransactions;

  final num inventoryValue;

  InventoryDashboardModel({
    required this.totalProducts,
    required this.lowStockProducts,
    required this.expiringProducts,
    required this.stockAdjustments,
    required this.inventoryTransactions,
    required this.inventoryValue,
  });

  factory InventoryDashboardModel.fromJson(Map<String, dynamic> json) {
    return InventoryDashboardModel(
      totalProducts: json['total_products'] ?? 0,

      lowStockProducts: json['low_stock_products'] ?? 0,

      expiringProducts: json['expiring_products'] ?? 0,

      stockAdjustments: json['stock_adjustments'] ?? 0,

      inventoryTransactions: json['inventory_transactions'] ?? 0,

      inventoryValue: json['inventory_value'] ?? 0,
    );
  }
}
