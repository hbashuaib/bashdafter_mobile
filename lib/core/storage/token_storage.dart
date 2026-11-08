import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/models/user_profile.dart';

class TokenStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: 'access', value: access);
    await _storage.write(key: 'refresh', value: refresh);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access');
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh');
  }

  static Future<void> saveProfile(UserProfile profile) async {
    await _storage.write(key: 'profile', value: jsonEncode(profile.toJson()));
  }

  static Future<UserProfile?> getProfile() async {
    final data = await _storage.read(key: 'profile');

    if (data == null) {
      return null;
    }

    return UserProfile.fromJson(jsonDecode(data));
  }

  static Future<String?> getRole() async {
    final profile = await getProfile();

    return profile?.role;
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
