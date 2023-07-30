import 'dart:async';

import 'package:meta/meta.dart';

import 'api/api_auth_provider.dart';
import 'api/auth_api.dart';
import 'data_access/auth_dao.dart';

class AuthService {
  bool get isAuthenticated => apiAuthProvider.isAuthenticated;

  Stream<void> get onLogout => _onLogoutSubject.stream;

  AuthService({
    required this.authApi,
    required this.apiAuthProvider,
    required this.authDao,
  }) {
    apiAuthProvider.onAuthFailed.listen((event) async {
      logout();
    });
  }

  Future<void> init() async {
    var authToken = await authDao.authToken;

    if (authToken != null) {
      apiAuthProvider.setAuthToken(authToken);
    }
  }

  Future<void> login({required String login, required String password}) async {
    final String authToken;
    final String userId;

    final response = await authApi.login(login, password);
    authToken = response.token;
    userId = response.userId;

    apiAuthProvider.setAuthToken(authToken);
    await authDao.setAuthToken(authToken);
    await authDao.setUserId(userId);
  }

  Future<void> logout() async {
    await authDao.deleteAuthToken();
    apiAuthProvider.resetAuthToken();
    _onLogoutSubject.sink.add(null);
  }

  @protected
  final AuthApi authApi;
  final ApiAuthProvider apiAuthProvider;
  final AuthDao authDao;

  final _onLogoutSubject = StreamController<void>.broadcast();
}
