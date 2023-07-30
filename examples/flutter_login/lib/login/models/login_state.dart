import 'package:formz/formz.dart';
import 'package:subtree/state.dart';

import 'password.dart';
import 'username.dart';

final class LoginState {
  final status = Rx(FormzSubmissionStatus.initial);
  final username = Rx(const Username.pure());
  final password = Rx(const Password.pure());
  final isValid = Rx(false);
}
