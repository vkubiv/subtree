import 'package:meta/meta.dart';

import '../model/user_profile.dart';
import 'api_auth_provider.dart';
import 'api_transport.dart';

class UserApi {
  UserApi({required this.apiAuthProvider, required this.apiTransport});

  Future<UserProfile> getMyProfile() async {
    final httpClient = apiAuthProvider.addAuth(apiTransport.createHttpClient());

    Map<String, dynamic> json = (await httpClient.get('/user/me')).data;
    return UserProfile(firstName: json["firstName"], lastName: json["lastName"], userID: json["id"]);
  }

  @protected
  final ApiAuthProvider apiAuthProvider;
  @protected
  final ApiTransport apiTransport;
}
