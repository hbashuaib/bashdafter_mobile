class CustomerModel {
  final int id;

  final num balance;

  final String name;
  final String phone;
  final String address;
  final String notes;

  final bool isActive;

  final String createdAt;
  final String updatedAt;

  final int? shop;

  CustomerModel({
    required this.id,
    required this.balance,
    required this.name,
    required this.phone,
    required this.address,
    required this.notes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.shop,
  });

  factory CustomerModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerModel(
      id: json['id'] ?? 0,

      balance: json['balance'] ?? 0,

      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      notes: json['notes'] ?? '',

      isActive: json['is_active'] ?? true,

      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',

      shop: json['shop'],
    );
  }
}