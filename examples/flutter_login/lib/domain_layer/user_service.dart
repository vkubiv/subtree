import 'api/user_api.dart';
import 'model/user_profile.dart';

class UserService {
  const UserService({
    required UserApi userApi,
  }) : _userApi = userApi;

  Future<UserProfile> getMyProfile() {
    return _userApi.getMyProfile();
  }

  final UserApi _userApi;
}
