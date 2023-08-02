import 'dart:async';

import 'package:flutter_login/domain_layer/api/auth_api.dart';
import 'package:flutter_login/domain_layer/auth_service.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockOnLoggedIn extends Mock {
  void call();
}

class MockAuthService extends Mock implements AuthService {}

void main() {
  late void Function() onLoggedIn;
  late AuthService authService;

  setUp(() {
    onLoggedIn = MockOnLoggedIn();
    authService = MockAuthService();
  });

  group('LoginController', () {
    test('initial state is LoginState', () {
      final controller = LoginController(authService: authService, onLoggedIn: onLoggedIn);
      expect(controller.state.status.value, FormzSubmissionStatus.initial);
    });

    group('LoginSubmitted', () {
      test('when login succeeds', () async {
        final loginCompleter = Completer<void>();

        when(() => authService.login(login: 'username', password: 'password')).thenAnswer((_) => loginCompleter.future);

        final controller = LoginController(authService: authService, onLoggedIn: onLoggedIn);
        final state = controller.state;

        controller.usernameChanged('username');
        expect(state.username.value, Username.dirty('username'));
        expect(state.password.value, Password.pure());
        expect(state.isValid.value, false);

        controller.passwordChanged('password');
        expect(state.username.value, Username.dirty('username'));
        expect(state.password.value, Password.dirty('password'));
        expect(state.isValid.value, true);

        controller.loginSubmitted();

        expect(state.username.value, Username.dirty('username'));
        expect(state.password.value, Password.dirty('password'));
        expect(state.isValid.value, true);
        expect(state.status.value, FormzSubmissionStatus.inProgress);

        loginCompleter.complete();
        await loginCompleter.future;

        expect(state.username.value, Username.dirty('username'));
        expect(state.password.value, Password.dirty('password'));
        expect(state.isValid.value, true);
        expect(state.status.value, FormzSubmissionStatus.success);

        verify(() => authService.login(login: 'username', password: 'password')).called(1);
      });

      test('when logIn fails', () async {
        final loginCompleter = Completer<void>();

        when(() => authService.login(login: 'username', password: 'password')).thenAnswer((_) => loginCompleter.future);

        final controller = LoginController(authService: authService, onLoggedIn: onLoggedIn);
        final state = controller.state;

        controller.usernameChanged('username');
        controller.passwordChanged('password');
        controller.loginSubmitted();

        expect(state.username.value, Username.dirty('username'));
        expect(state.password.value, Password.dirty('password'));
        expect(state.isValid.value, true);
        expect(state.status.value, FormzSubmissionStatus.inProgress);

        loginCompleter.completeError(InvalidCredentials());
        await loginCompleter.future.catchError((e) {});

        expect(state.username.value, Username.dirty('username'));
        expect(state.password.value, Password.dirty('password'));
        expect(state.isValid.value, true);
        expect(state.status.value, FormzSubmissionStatus.failure);
        expect(state.errorEvent.value, isNot(null));

        verify(() => authService.login(login: 'username', password: 'password')).called(1);
      });
    });
  });
}
