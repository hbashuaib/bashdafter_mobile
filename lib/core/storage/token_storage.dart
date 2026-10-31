import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {

  static const _storage =
      FlutterSecureStorage();

  static Future<void> saveTokens({

    required String access,

    required String refresh,

  }) async {

    await _storage.write(
      key: 'access',
      value: access,
    );

    await _storage.write(
      key: 'refresh',
      value: refresh,
    );
  }

  static Future<String?> getAccessToken()
  async {
    return await _storage.read(
      key: 'access',
    );
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}