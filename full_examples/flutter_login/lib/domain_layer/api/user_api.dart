// coverage:ignore-file
// Api module should be tested on integration level.

import '../model/user_profile.dart';
import 'api_auth_provider.dart';
import 'api_transport.dart';

class UserApi {
  UserApi({required ApiAuthProvider apiAuthProvider, required ApiTransport apiTransport})
      : _apiTransport = apiTransport,
        _apiAuthProvider = apiAuthProvider;

  Future<UserProfile> getMyProfile() async {
    final httpClient = _apiAuthProvider.addAuth(_apiTransport.createHttpClient());

    Map<String, dynamic> json = (await httpClient.get('/user/me')).data;
    return UserProfile(firstName: json["firstName"], lastName: json["lastName"], userID: json["id"]);
  }

  final ApiAuthProvider _apiAuthProvider;
  final ApiTransport _apiTransport;
}
