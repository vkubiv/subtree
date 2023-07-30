import 'package:flutter/material.dart';
import 'package:flutter_login/domain_layer/auth_service.dart';
import 'package:flutter_login/domain_layer/services.dart';
import 'package:flutter_login/home/home.dart';
import 'package:flutter_login/home/home_controller.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_login/splash/splash.dart';
import 'package:subtree/subtree.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ControlledSubtree(
        subtree: MaterialApp(
          navigatorKey: _navigatorKey,
          onGenerateRoute: (_) => SplashPage.route(),
        ),
        controller: () => AppRouter(_navigatorKey));
  }
}

class AppRouter extends SubtreeController {
  final GlobalKey<NavigatorState> _navigatorKey;

  NavigatorState get _navigator => _navigatorKey.currentState!;

  late final Services services;

  AppRouter(this._navigatorKey) {
    _setupApp();
  }

  void _setupApp() async {
    services = await createServices();

    services.authService.onLogout.listen((event) {
      _pushAsRoot(_loginRoute());
    });

    if (services.authService.isAuthenticated) {
      _onLoggedIn();
    } else {
      _pushAsRoot(_loginRoute());
    }
  }

  void _onLoggedIn() {
    _pushAsRoot(_homeRoute());
  }

  void _pushAsRoot(Route<void> route) {
    _navigator.pushAndRemoveUntil<void>(
      route,
      (route) => false,
    );
  }

// routes
  Route<void> _homeRoute() {
    return MaterialPageRoute<void>(
        builder: (_) => ControlledSubtree(
              subtree: const HomePage(),
              controller: () => HomeController(userService: services.userService, authService: services.authService),
            ));
  }

  Route<void> _loginRoute() {
    return MaterialPageRoute<void>(
        builder: (_) => ControlledSubtree(
            subtree: const LoginPage(),
            controller: () => LoginController(authService: services.authService, onLoggedIn: _onLoggedIn)));
  }
}
