class ProductModel {
  final int id;

  final num totalSold;
  final num totalAdjustments;

  final String name;
  final String nameEn;
  final String nameAr;
  final String displayName;

  final String? barcode;
  final String description;

  final String costPrice;
  final String sellingPrice;

  final String minimumStock;
  final String currentStock;

  final bool hasExpiry;
  final String? expiryDate;

  final bool isActive;

  final int? category;
  final int? unit;

  final String categoryName;
  final String unitName;

  final bool isLowStock;

  ProductModel({
    required this.id,
    required this.totalSold,
    required this.totalAdjustments,
    required this.name,
    required this.nameEn,
    required this.nameAr,
    required this.displayName,
    this.barcode,
    required this.description,
    required this.costPrice,
    required this.sellingPrice,
    required this.minimumStock,
    required this.currentStock,
    required this.hasExpiry,
    this.expiryDate,
    required this.isActive,
    this.category,
    this.unit,
    required this.categoryName,
    required this.unitName,
    required this.isLowStock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      
      totalSold: json['total_sold'] ?? 0,
      totalAdjustments: json['total_adjustments'] ?? 0,

      name: json['name'] ?? '',
      nameEn: json['name_en'] ?? '',
      nameAr: json['name_ar'] ?? '',
      displayName: json['display_name'] ?? json['name'] ?? '',

      barcode: json['barcode'],
      description: json['description'] ?? '',

      costPrice: json['cost_price']?.toString() ?? '0',

      sellingPrice: json['selling_price']?.toString() ?? '0',

      minimumStock: json['minimum_stock']?.toString() ?? '0',

      currentStock: json['current_stock']?.toString() ?? '0',

      hasExpiry: json['has_expiry'] ?? false,

      expiryDate: json['expiry_date']?.toString(),

      isActive: json['is_active'] ?? true,

      category: json['category'],
      unit: json['unit'],

      categoryName: json['category_name'] ?? '',

      unitName: json['unit_name'] ?? '',

      isLowStock: json['is_low_stock'] ?? false,
    );
  }
}
