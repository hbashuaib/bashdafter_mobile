import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

class UserService {
  Future<List<dynamic>> getUsers() async {
    final dio = await ApiClient.instance;
    final response = await dio.get('/users/');
    return response.data;
  }

  Future<List<dynamic>> getInactiveUsers() async {
    final dio = await ApiClient.instance;
    final response = await dio.get('/users/inactive/');
    return response.data;
  }

  Future<void> createUser({
    required String username,
    required String password,
    required String role,
  }) async {
    final dio = await ApiClient.instance;

    await dio.post(
      '/users/',
      data: {'username': username, 'password': password, 'role': role},
    );
  }

  Future<void> updateUser({
    required int id,
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String role,
    required int? shop,
    required bool isActive,
  }) async {
    final dio = await ApiClient.instance;

    await dio.put(
      '/users/$id/',
      data: {
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'role': role,
        'shop': shop,
        'is_active': isActive,
      },
    );
  }

  Future<void> deleteUser(int id) async {
    final dio = await ApiClient.instance;
    await dio.delete('/users/$id/');
  }

  Future<void> restoreUser(int id) async {
    final dio = await ApiClient.instance;
    await dio.post('/users/$id/restore/');
  }

  Future<void> resetPassword({
    required int id,
    required String password,
  }) async {
    final dio = await ApiClient.instance;

    await dio.post(
      '/users/$id/reset_password/',
      data: {'new_password': password},
    );
  }
}
