class ShopModel {
  final int id;

  final String name;

  final String phone;

  final String address;

  final String city;

  final String currency;

  final bool isActive;

  final String createdAt;

  final String updatedAt;

  final int owner;

  ShopModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.currency,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.owner,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'] ?? 0,

      name: json['name'] ?? '',

      phone: json['phone'] ?? '',

      address: json['address'] ?? '',

      city: json['city'] ?? '',

      currency: json['currency'] ?? 'YER',

      isActive: json['is_active'] ?? true,

      createdAt: json['created_at'] ?? '',

      updatedAt: json['updated_at'] ?? '',

      owner: json['owner'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'name': name,

      'phone': phone,

      'address': address,

      'city': city,

      'currency': currency,

      'is_active': isActive,

      'created_at': createdAt,

      'updated_at': updatedAt,

      'owner': owner,
    };
  }
}
