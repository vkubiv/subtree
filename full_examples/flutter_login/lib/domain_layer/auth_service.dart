import 'dart:async';

import 'api/api_auth_provider.dart';
import 'api/auth_api.dart';
import 'data_access/auth_dao.dart';

class AuthService {
  bool get isAuthenticated => _apiAuthProvider.isAuthenticated;

  Stream<void> get onLogout => _onLogoutSubject.stream;

  AuthService({
    required AuthApi authApi,
    required ApiAuthProvider apiAuthProvider,
    required AuthDao authDao,
  })  : _authDao = authDao,
        _apiAuthProvider = apiAuthProvider,
        _authApi = authApi {
    _apiAuthProvider.onAuthFailed.listen((event) async {
      logout();
    });
  }

  Future<void> init() async {
    var authToken = await _authDao.authToken;

    if (authToken != null) {
      _apiAuthProvider.setAuthToken(authToken);
    }
  }

  Future<void> login({required String login, required String password}) async {
    final String authToken;
    final String userId;

    final response = await _authApi.login(login, password);
    authToken = response.token;
    userId = response.userId;

    _apiAuthProvider.setAuthToken(authToken);
    await _authDao.setAuthToken(authToken);
    await _authDao.setUserId(userId);
  }

  Future<void> logout() async {
    await _authDao.deleteAuthToken();
    _apiAuthProvider.resetAuthToken();
    _onLogoutSubject.sink.add(null);
  }

  final AuthApi _authApi;
  final ApiAuthProvider _apiAuthProvider;
  final AuthDao _authDao;

  final _onLogoutSubject = StreamController<void>.broadcast();
}
