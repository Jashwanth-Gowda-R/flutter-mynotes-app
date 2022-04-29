// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_services.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  register() async {
    try {
      var emailAddress = _email.text;
      var password = _password.text;
      await AuthService.firebase().createUser(
        email: emailAddress,
        password: password,
      );
      // final user = AuthService.firebase().currentUser;
      await AuthService.firebase().sendEmailverification();
      Navigator.of(context).pushNamed(verifyEmailRoute);
    } on EmailAlreadyInUseAuthException {
      print('User already registered');
      await showErrorDialog(context, 'Error : User already registered');
    } on WeakPasswordAuthException {
      print('weak password');
      await showErrorDialog(context, 'Error : weak password');
    } on InvalidEmailAuthException {
      print('invalid email');
      await showErrorDialog(context, 'Error : invalid email');
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
        title: const Text('Register'),
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
              register();
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already Registered? Click to Login...'),
          ),
        ],
      ),
    );
  }
}
