import 'package:meta/meta.dart';

import 'api/user_api.dart';
import 'model/user_profile.dart';

class UserService {
  @protected
  final UserApi userApi;

  const UserService({
    required this.userApi,
  });

  Future<UserProfile> getMyProfile() {
    return userApi.getMyProfile();
  }
}