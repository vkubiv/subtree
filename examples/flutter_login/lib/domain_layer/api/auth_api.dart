import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import 'api_transport.dart';


class LoginResponse {
  final String token;
  final String userId;

  LoginResponse({required this.userId, required this.token});
}

class InvalidCredentials implements Exception {}

class DuplicatedEmail implements Exception {}

class AuthApi {
  @protected
  final ApiTransport apiTransport;
  @protected
  final bool demoMode;

  AuthApi({required this.apiTransport, required this.demoMode});

  Future<LoginResponse> login(String login, String password) async {
    if (demoMode) {
      return LoginResponse(token: '__demo__', userId: Uuid().v4());
    }

    try {
      final response =
          await apiTransport.createHttpClient().post('/login', data: {'userName': login, 'password': password});

      print("response.data: ${response.data}");
      return LoginResponse(userId: response.data['id'].toString(), token: response.data['token'].toString());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw InvalidCredentials();
      }
      throw e;
    }
  }
}
