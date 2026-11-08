class UserModel {
  final int id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String role;
  final int? shop;
  final bool isActive;

  UserModel({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    required this.role,
    this.shop,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      role: json['role'] ?? '',
      shop: json['shop'],
      isActive: json['is_active'] ?? true,
    );
  }
}
