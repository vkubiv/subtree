import 'package:flutter/material.dart';
import 'package:flutter_login/login/models/login_actions.dart';
import 'package:formz/formz.dart';
import 'package:subtree/subtree.dart';
import 'package:subtree/state.dart';

import '../models/login_state.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.get<LoginState>();

    return EventListener(
      event: state.errorEvent,
      listener: (context, errorMessage) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UsernameInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _LoginButton(),
          ],
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.get<LoginState>();
    final actions = context.get<LoginActions>();

    return Obx(
      (ref) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (username) => actions.usernameChanged(username),
          decoration: InputDecoration(
            labelText: 'username',
            errorText: ref.watch(state.username).displayError != null ? 'invalid username' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.get<LoginState>();
    final actions = context.get<LoginActions>();

    return Obx(
      (ref) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) => actions.passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            errorText: ref.watch(state.password).displayError != null ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.get<LoginState>();
    final actions = context.get<LoginActions>();

    return Obx(
      (ref) {
        return ref.watch(state.status).isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                onPressed: ref.watch(state.isValid) ? actions.loginSubmitted : null,
                child: const Text('Login'),
              );
      },
    );
  }
}
