import 'api/api.dart';
import 'api/api_auth_provider.dart';
import 'auth_service.dart';
import 'data_access/auth_dao.dart';
import 'user_service.dart';

class Services {
  final AuthService authService;
  final UserService userService;

  const Services({
    required this.authService,
    required this.userService,
  });

  void dispose() {}
}

Future<Services> createServices() async {
  final baseApiUrl = "https://example.com/";
  final apiAuthProvider = ApiAuthProvider();

  final api = createApiModule(baseApiUrl: baseApiUrl, apiAuthProvider: apiAuthProvider, demoMode: true);

  final authDao = AuthDao();

  final authService = AuthService(apiAuthProvider: apiAuthProvider, authApi: api.auth, authDao: authDao);
  await authService.init();

  final userService = UserService(userApi: api.user);

  return Services(authService: authService, userService: userService);
}
