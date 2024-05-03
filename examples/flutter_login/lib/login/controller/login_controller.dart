import 'package:flutter/cupertino.dart';
import 'package:flutter_login/domain_layer/auth_service.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_login/login/models/login_actions.dart';
import 'package:formz/formz.dart';
import 'package:subtree/subtree.dart';

import '../models/login_state.dart';

class LoginController extends SubtreeController implements LoginActions {
  @visibleForTesting
  final state = LoginState();

  LoginController({
    required this.authService,
    required this.onLoggedIn,
  }) {
    subtreeModel.put(state);
    subtreeModel.put<LoginActions>(this);
  }

  @override
  void usernameChanged(String username) {
    state.username.value = Username.dirty(username);
    state.isValid.value = Formz.validate([state.password.value, state.username.value]);
  }

  @override
  void passwordChanged(String password) {
    state.password.value = Password.dirty(password);
    state.isValid.value = Formz.validate([state.password.value, state.username.value]);
  }

  @override
  void loginSubmitted() async {
    if (state.isValid.value) {
      state.status.value = FormzSubmissionStatus.inProgress;

      try {
        await authService.login(
          login: state.username.value.value,
          password: state.password.value.value,
        );
        state.status.value = FormzSubmissionStatus.success;

        onLoggedIn();
      } catch (_) {
        state.status.value = FormzSubmissionStatus.failure;
        state.errorEvent.emit('Authentication Failure');
      }
    }
  }

  @protected
  AuthService authService;

  @protected
  void Function() onLoggedIn;
}
