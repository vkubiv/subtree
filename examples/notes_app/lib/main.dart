import 'package:flutter/material.dart';

import 'app.dart';

void main() async {
  final application = AppRoot();

  await application.setupServices();

  runApp(AppWidget(routerConfig: application.linkScreens()));
}

class AppWidget extends StatelessWidget {
  final RouterConfig<Object> routerConfig;

  const AppWidget({super.key, required this.routerConfig});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routerConfig: routerConfig,
    );
  }
}
