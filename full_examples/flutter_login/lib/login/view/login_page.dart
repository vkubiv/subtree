import 'package:flutter/material.dart';
import 'package:flutter_login/login/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Padding(
        padding: EdgeInsets.all(12),
        child: LoginForm(),
      ),
    );
  }
}
