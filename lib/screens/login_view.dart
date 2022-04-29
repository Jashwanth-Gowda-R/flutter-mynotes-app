// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_services.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  login() async {
    try {
      var emailAddress = _email.text;
      var password = _password.text;
      var userCred = await AuthService.firebase().logIn(
        email: emailAddress,
        password: password,
      );
      print(userCred);
      var user = AuthService.firebase().currentUser;
      if (user?.isEmailVerified ?? false) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(notesRoute, (route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
      }
    } on UserNotFoundAuthException {
      await showErrorDialog(context, 'User not found');
    } on WrongPasswordAuthException {
      await showErrorDialog(context, 'Wrong Credentials');
    } on GenericAuthException {
      await showErrorDialog(context, 'Error : Authentication Error');
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter Your Email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter Your Password here',
            ),
          ),
          TextButton(
            onPressed: () {
              login();
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not Registered Yet! Click to Register...'),
          ),
        ],
      ),
    );
  }
}
