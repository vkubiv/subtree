import 'dart:async';

import 'package:flutter_login/app.dart';
import 'package:flutter_login/domain_layer/auth_service.dart';
import 'package:flutter_login/domain_layer/model/user_profile.dart';
import 'package:flutter_login/domain_layer/services.dart';
import 'package:flutter_login/domain_layer/user_service.dart';
import 'package:flutter_login/home/home.dart';
import 'package:flutter_login/login/view/login_page.dart';
import 'package:flutter_login/splash/splash.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserService extends Mock implements UserService {}

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockUserService userService;
  late MockAuthService authService;

  late StreamController<void> onLogoutSubject;

  Future<Services> createServices() async {
    return Services(authService: authService, userService: userService);
  }

  setUp(() {
    userService = MockUserService();
    authService = MockAuthService();
    onLogoutSubject = StreamController<void>.broadcast();

    when(() => authService.onLogout).thenAnswer((_) => onLogoutSubject.stream);
    when(() => userService.getMyProfile()).thenAnswer((_) async {
      return UserProfile(firstName: 'firstName', lastName: 'lastName', userID: 'userID');
    });
  });

  testWidgets('App initial state', (tester) async {
    when(() => authService.isAuthenticated).thenReturn(false);

    await tester.pumpWidget(AppWidget(createServices: createServices));

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);

    await tester.pumpAndSettle();

    expect(find.byType(SplashPage), findsNothing);
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('App logged in state', (tester) async {
    when(() => authService.isAuthenticated).thenReturn(true);

    await tester.pumpWidget(AppWidget(createServices: createServices));

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);

    await tester.pumpAndSettle();

    expect(find.byType(SplashPage), findsNothing);
    expect(find.byType(HomePage), findsOneWidget);

    onLogoutSubject.sink.add(null);

    await tester.pumpAndSettle();

    expect(find.byType(SplashPage), findsNothing);
    expect(find.byType(HomePage), findsNothing);
    expect(find.byType(LoginPage), findsOneWidget);

    await tester.pumpAndSettle();
  });
}
