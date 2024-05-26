import 'package:flutter_login/domain_layer/auth_service.dart';
import 'package:flutter_login/domain_layer/user_service.dart';
import 'package:flutter_login/home/models.dart';
import 'package:meta/meta.dart';
import 'package:subtree/subtree.dart';

class HomeController extends SubtreeController implements HomeActions {
  @visibleForTesting
  final state = HomeState();

  HomeController({required this.userService, required this.authService}) {
    subtree.put(state);
    subtree.put<HomeActions>(this);
    loadUser();
  }

  void loadUser() async {
    try {
      state.userProfile.value = await userService.getMyProfile();
    } catch (e) {
      state.errorEvent.emit(e.toString());
    }
  }

  @override
  void logout() {
    authService.logout();
  }

  @protected
  UserService userService;

  @protected
  AuthService authService;
}
