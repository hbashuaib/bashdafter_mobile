class UserProfile {
  final int id;

  final String username;

  final String firstName;
  final String lastName;

  final String role;

  final String email;
  final String phoneNumber;

  final String profileImage;

  final bool isStaff;

  UserProfile({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.isStaff,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,

      username: json['username'] ?? '',

      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',

      role: json['role'] ?? '',

      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',

      profileImage: json['profile_image'] ?? '',

      isStaff: json['is_staff'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'username': username,

      'first_name': firstName,
      'last_name': lastName,

      'role': role,

      'email': email,
      'phone_number': phoneNumber,

      'profile_image': profileImage,

      'is_staff': isStaff,
    };
  }

  bool get isOwner => role == 'OWNER';

  bool get isAdmin => role == 'ADMIN';

  bool get isManager => role == 'MANAGER';

  bool get isCashier => role == 'CASHIER';

  String get fullName {
    final name = '$firstName $lastName'.trim();

    return name.isEmpty ? username : name;
  }
}
