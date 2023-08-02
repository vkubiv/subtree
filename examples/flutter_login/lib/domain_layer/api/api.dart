// coverage:ignore-file
// Api module should be tested on integration level.

import 'package:dio/dio.dart';

import 'api_auth_provider.dart';
import 'api_transport.dart';
import 'auth_api.dart';
import 'user_api.dart';

class ApiModule {
  final AuthApi auth;
  final UserApi user;

  const ApiModule({
    required this.auth,
    required this.user,
  });
}

ApiModule createApiModule(
    {required String baseApiUrl, required ApiAuthProvider apiAuthProvider, bool demoMode = false}) {
  var apiTransport = ApiTransport(baseApiUrl: baseApiUrl);
  if (demoMode) {
    apiTransport = DemoApiTransport(apiTransport);
  }
  return ApiModule(
      auth: AuthApi(apiTransport: apiTransport, demoMode: demoMode),
      user: UserApi(apiTransport: apiTransport, apiAuthProvider: apiAuthProvider));
}

class DemoApiTransport implements ApiTransport {
  DemoApiTransport(this._apiTransport);

  @override
  Dio createHttpClient() {
    final httpClient = _apiTransport.createHttpClient();

    httpClient.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      final String? authHeader = options.headers['Authorization'];

      if (authHeader != null && authHeader.contains('__demo__')) {
        if (options.uri.path == '/user/me') {
          handler.resolve(Response(data: {
            'firstName': 'John',
            'lastName': 'Smith',
            'id': 'demo_id',
          }, statusCode: 200, statusMessage: 'OK', requestOptions: options));
          return;
        }
      }

      handler.next(options);
    }));

    return httpClient;
  }

  final ApiTransport _apiTransport;
}
