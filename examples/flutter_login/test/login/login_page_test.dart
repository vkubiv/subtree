// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_login/login/models/login_actions.dart';
import 'package:flutter_login/login/models/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:subtree/subtree.dart';

class MockLoginActions extends Mock implements LoginActions {}

void main() {
  group('LoginForm', () {
    late SubtreeModelContainer subtreeModel;
    late MockLoginActions actions;
    late LoginState state;

    setUp(() {
      subtreeModel = SubtreeModelContainer();
      actions = MockLoginActions();
      state = LoginState();

      subtreeModel.putState(state);
      subtreeModel.putActions<LoginActions>(actions);
    });

    testWidgets('username and password changed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubtreeModelProvider(
              subtreeModel,
              child: LoginPage(),
            ),
          ),
        ),
      );

      const username = 'username';
      await tester.enterText(
        find.byKey(const Key('loginForm_usernameInput_textField')),
        username,
      );

      verify(
        () => actions.usernameChanged(username),
      ).called(1);

      const password = 'password';
      await tester.enterText(
        find.byKey(const Key('loginForm_passwordInput_textField')),
        password,
      );
      verify(
        () => actions.passwordChanged(password),
      ).called(1);
    });

    testWidgets('continue button is disabled by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubtreeModelProvider(
              subtreeModel,
              child: LoginPage(),
            ),
          ),
        ),
      );
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, isFalse);
    });

    testWidgets('loading indicator is shown when status is submission in progress', (tester) async {
      state.status.value = FormzSubmissionStatus.inProgress;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubtreeModelProvider(
              subtreeModel,
              child: LoginPage(),
            ),
          ),
        ),
      );
      expect(find.byType(ElevatedButton), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('continue button is enabled when status is validated', (tester) async {
      state.isValid.value = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubtreeModelProvider(
              subtreeModel,
              child: LoginPage(),
            ),
          ),
        ),
      );
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.enabled, isTrue);
    });

    testWidgets('Action loginSubmitted is called when continue is tapped', (tester) async {
      state.isValid.value = true;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubtreeModelProvider(
              subtreeModel,
              child: LoginPage(),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(ElevatedButton));
      verify(() => actions.loginSubmitted()).called(1);
    });

    testWidgets('shows SnackBar when status is submission failure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubtreeModelProvider(
              subtreeModel,
              child: LoginPage(),
            ),
          ),
        ),
      );
      state.errorEvent.emit('Error message');
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
