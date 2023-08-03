import 'package:dio/dio.dart';
import 'package:flutter_login/domain_layer/api/api_auth_provider.dart';
import 'package:flutter_login/domain_layer/api/auth_api.dart';
import 'package:flutter_login/domain_layer/auth_service.dart';
import 'package:flutter_login/domain_layer/data_access/auth_dao.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthApi extends Mock implements AuthApi {}

class MockAuthDao extends Mock implements AuthDao {}

void main() {
  late ApiAuthProvider authProvider;
  late MockAuthDao authDao;
  late MockAuthApi authApi;

  setUp(() {
    authProvider = ApiAuthProvider();
    authDao = MockAuthDao();
    authApi = MockAuthApi();
  });

  test('token stored', () async {
    when(() => authDao.authToken).thenAnswer((_) async {
      return 'token';
    });

    final service = AuthService(apiAuthProvider: authProvider, authDao: authDao, authApi: authApi);
    await service.init();
    expect(service.isAuthenticated, true);
    expect(authProvider.isAuthenticated, true);
  });

  test('no token stored', () async {
    when(() => authDao.authToken).thenAnswer((_) async {
      return null;
    });

    final service = AuthService(apiAuthProvider: authProvider, authDao: authDao, authApi: authApi);
    await service.init();
    expect(service.isAuthenticated, false);
    expect(authProvider.isAuthenticated, false);
  });

  test('login successful', () async {
    when(() => authDao.authToken).thenAnswer((_) async {
      return null;
    });

    when(() => authApi.login(any(), any())).thenAnswer((_) async {
      return LoginResponse(userId: 'userId', token: 'token');
    });

    when(() => authDao.setAuthToken('token')).thenAnswer((_) async {});
    when(() => authDao.setUserId('userId')).thenAnswer((_) async {});

    final service = AuthService(apiAuthProvider: authProvider, authDao: authDao, authApi: authApi);
    await service.init();
    expect(service.isAuthenticated, false);
    expect(authProvider.isAuthenticated, false);

    await service.login(login: 'login', password: 'password');

    expect(service.isAuthenticated, true);
    expect(authProvider.isAuthenticated, true);
  });

  test('logout successful', () async {
    when(() => authDao.authToken).thenAnswer((_) async {
      return "token";
    });

    final service = AuthService(apiAuthProvider: authProvider, authDao: authDao, authApi: authApi);
    await service.init();
    expect(service.isAuthenticated, true);
    expect(authProvider.isAuthenticated, true);

    when(() => authDao.deleteAuthToken()).thenAnswer((_) async {});

    bool logoutCalled = false;
    service.onLogout.listen((event) {
      logoutCalled = true;
    });

    await service.logout();
    await Future.delayed(Duration.zero);

    expect(logoutCalled, true);
    expect(service.isAuthenticated, false);
    expect(authProvider.isAuthenticated, false);
  });

  test('Auth failed', () async {
    when(() => authDao.authToken).thenAnswer((_) async {
      return "token";
    });

    final service = AuthService(apiAuthProvider: authProvider, authDao: authDao, authApi: authApi);
    await service.init();
    expect(service.isAuthenticated, true);
    expect(authProvider.isAuthenticated, true);

    when(() => authDao.deleteAuthToken()).thenAnswer((_) async {});

    bool logoutCalled = false;
    service.onLogout.listen((event) {
      logoutCalled = true;
    });

    await service.logout();
    await Future.delayed(Duration.zero);

    expect(logoutCalled, true);
    expect(service.isAuthenticated, false);
    expect(authProvider.isAuthenticated, false);
  });

  test('auth provided', () async {
    when(() => authDao.authToken).thenAnswer((_) async {
      return '__token__';
    });

    final service = AuthService(apiAuthProvider: authProvider, authDao: authDao, authApi: authApi);
    await service.init();
    expect(service.isAuthenticated, true);
    expect(authProvider.isAuthenticated, true);

    final httpClient = authProvider.addAuth(Dio());

    final headers = httpClient.options.headers;
    expect(headers['Authorization'], contains('__token__'));
  });

  test('token expired', () async {
    when(() => authDao.authToken).thenAnswer((_) async {
      return '__token__';
    });
    when(() => authDao.deleteAuthToken()).thenAnswer((_) async {});

    final service = AuthService(apiAuthProvider: authProvider, authDao: authDao, authApi: authApi);
    await service.init();
    expect(service.isAuthenticated, true);
    expect(authProvider.isAuthenticated, true);

    bool logoutCalled = false;
    service.onLogout.listen((event) {
      logoutCalled = true;
    });

    final basicHttpClient = Dio();
    basicHttpClient.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.reject(
            DioException(
                requestOptions: options,
                message: 'Unauthorized',
                response: Response(data: {}, statusCode: 401, statusMessage: 'Unauthorized', requestOptions: options)),
            true);
      },
    ));

    final httpClient = authProvider.addAuth(basicHttpClient);
    try {
      await httpClient.get("test url");
      fail("exception not thrown");
    // ignore: empty_catches
    } on DioException {}

    await Future.delayed(Duration.zero);
    expect(logoutCalled, true);
  });

  test('by pass not related to auth errors', () async {
    when(() => authDao.authToken).thenAnswer((_) async {
      return '__token__';
    });

    final service = AuthService(apiAuthProvider: authProvider, authDao: authDao, authApi: authApi);
    await service.init();
    expect(service.isAuthenticated, true);
    expect(authProvider.isAuthenticated, true);

    bool logoutCalled = false;
    service.onLogout.listen((event) {
      logoutCalled = true;
    });

    final basicHttpClient = Dio();
    basicHttpClient.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.reject(
            DioException(
                requestOptions: options,
                message: 'BadRequestUnauthorized',
                response: Response(data: {}, statusCode: 500, statusMessage: 'BadRequest', requestOptions: options)),
            true);
      },
    ));

    final httpClient = authProvider.addAuth(basicHttpClient);
    try {
      await httpClient.get("test url");
      fail("exception not thrown");
    // ignore: empty_catches
    } on DioException {}

    await Future.delayed(Duration.zero);
    expect(logoutCalled, false);
  });
}
