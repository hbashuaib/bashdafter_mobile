class UserProfile {
  final int id;
  final String username;
  final String role;
  final String? email;
  final String? phoneNumber;

  UserProfile({
    required this.id,
    required this.username,
    required this.role,
    this.email,
    this.phoneNumber,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      email: json['email'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role,
      'email': email,
      'phone_number': phoneNumber,
    };
  }

  bool get isOwner => role == 'OWNER';
  bool get isAdmin => role == 'ADMIN';
  bool get isManager => role == 'MANAGER';
  bool get isCashier => role == 'CASHIER';
}
