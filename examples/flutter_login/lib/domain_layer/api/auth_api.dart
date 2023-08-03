// coverage:ignore-file
// Api module should be tested on integration level.

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
  final ApiTransport _apiTransport;
  final bool _demoMode;

  AuthApi({required ApiTransport apiTransport, required bool demoMode}) : _demoMode = demoMode, _apiTransport = apiTransport;

  Future<LoginResponse> login(String login, String password) async {
    if (_demoMode) {
      if (password == 'fail') {
        throw InvalidCredentials();
      }
      return LoginResponse(token: '__demo__', userId: const Uuid().v4());
    }

    try {
      final response =
          await _apiTransport.createHttpClient().post('/login', data: {'userName': login, 'password': password});

      return LoginResponse(userId: response.data['id'].toString(), token: response.data['token'].toString());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw InvalidCredentials();
      }
      rethrow;
    }
  }
}
