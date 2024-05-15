import 'dart:async';

import 'package:flutter_login/domain_layer/auth_service.dart';
import 'package:flutter_login/domain_layer/model/user_profile.dart';
import 'package:flutter_login/domain_layer/user_service.dart';
import 'package:flutter_login/home/home_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserService extends Mock implements UserService {}

class MockAuthService extends Mock implements AuthService {}

void main() {
  late UserService userService;
  late AuthService authService;
  late Completer<UserProfile> getMyProfileCompleter;

  setUp(() {
    userService = MockUserService();
    authService = MockAuthService();

    getMyProfileCompleter = Completer<UserProfile>();
    when(() => userService.getMyProfile()).thenAnswer((_) => getMyProfileCompleter.future);

    when(() => authService.logout()).thenAnswer((_) async {});
  });

  group('HomeController', () {
    test('initial state', () {
      final controller = HomeController(authService: authService, userService: userService);
      expect(controller.state.userProfile.value, null);
      expect(controller.state.errorEvent.value, null);
    });

    test('initialized successfully', () async {
      final controller = HomeController(authService: authService, userService: userService);
      expect(controller.state.userProfile.value, null);
      expect(controller.state.errorEvent.value, null);
      getMyProfileCompleter.complete(UserProfile(firstName: 'firstName', lastName: 'lastName', userID: 'userID'));
      await getMyProfileCompleter.future;

      expect(controller.state.userProfile.value, isNot(null));
      expect(controller.state.errorEvent.value, null);

      final userProfile = controller.state.userProfile.value!;
      expect(userProfile.firstName, 'firstName');
      expect(userProfile.lastName, 'lastName');
      expect(userProfile.userID, 'userID');
    });

    test('initialized failed', () async {
      final controller = HomeController(authService: authService, userService: userService);
      expect(controller.state.userProfile.value, null);
      expect(controller.state.errorEvent.value, null);
      getMyProfileCompleter.completeError(Exception('ErrorMessage'));
      await getMyProfileCompleter.future
          .catchError((e) => UserProfile(firstName: 'firstName', lastName: 'lastName', userID: 'userID'));

      expect(controller.state.userProfile.value, null);
      expect(controller.state.errorEvent.value, contains('ErrorMessage'));
    });

    test('logout called', () {
      final controller = HomeController(authService: authService, userService: userService);
      controller.logout();

      verify(() => authService.logout()).called(1);
    });
  });
}
