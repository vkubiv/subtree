import 'package:flutter/material.dart';
import 'package:flutter_login/domain_layer/services.dart';
import 'package:flutter_login/home/home.dart';
import 'package:flutter_login/home/home_controller.dart';
import 'package:flutter_login/login/login.dart';
import 'package:flutter_login/splash/splash.dart';
import 'package:subtree/subtree.dart';

class AppWidget extends StatefulWidget {
  final Future<Services> Function() createServices;

  const AppWidget({super.key, required this.createServices});

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
          onGenerateRoute: (_) => AppController._splashPageRoute(),
        ),
        controller: (context) => AppController(_navigatorKey, widget.createServices));
  }
}

class AppController extends SubtreeController {
  final GlobalKey<NavigatorState> _navigatorKey;

  NavigatorState get _navigator => _navigatorKey.currentState!;

  late final Services services;

  AppController(this._navigatorKey, Future<Services> Function() createSrvs) {
    _setupApp(createSrvs);
  }

  void _setupApp(Future<Services> Function() createSrvs) async {
    services = await createSrvs();

    services.authService.onLogout.listen((event) {
      _pushAsRoot(_loginRoute());
    });

    if (services.authService.isAuthenticated) {
      _onLoggedIn();
    } else {
      _pushAsRoot(_loginRoute());
    }
  }

  Future<void> _onLoggedIn() {
    return _pushAsRoot(_homeRoute());
  }

  Future<void> _pushAsRoot(Route<void> route) {
    return _navigator.pushAndRemoveUntil<void>(
      route,
      (route) => false,
    );
  }

// routes
  Route<void> _homeRoute() {
    return MaterialPageRoute<void>(
        builder: (_) => ControlledSubtree(
              subtree: const HomePage(),
              controller: (context) =>
                  HomeController(userService: services.userService, authService: services.authService),
            ));
  }

  Route<void> _loginRoute() {
    return MaterialPageRoute<void>(
        builder: (_) => ControlledSubtree(
            subtree: const LoginPage(),
            controller: (context) => LoginController(authService: services.authService, onLoggedIn: _onLoggedIn)));
  }

  static Route<void> _splashPageRoute() {
    return MaterialPageRoute<void>(builder: (_) => const SplashPage());
  }
}
