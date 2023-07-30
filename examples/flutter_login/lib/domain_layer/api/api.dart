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

ApiModule createApiModule({required String baseApiUrl, required ApiAuthProvider apiAuthProvider, bool demoMode = false}) {
  final apiTransport = ApiTransport(baseApiUrl: baseApiUrl);
  return ApiModule(
      auth: AuthApi(apiTransport: apiTransport, demoMode: demoMode),
      user: UserApi(apiTransport: apiTransport, apiAuthProvider: apiAuthProvider));
}
