import 'package:flutter_login/domain_layer/model/user_profile.dart';
import 'package:subtree/state.dart';

class HomeState {
  final userProfile = Rx<UserProfile?>(null);
  final errorMessage = Rx<String?>(null);
}

abstract class HomeActions {
  void logout();
}
