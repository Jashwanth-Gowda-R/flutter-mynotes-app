// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      Navigator.of(context).pushNamed(verifyEmailRoute);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('User already registered');
        await showErrorDialog(context, 'Error : User already registered');
      } else if (e.code == 'weak-password') {
        print('weak password');
        await showErrorDialog(context, 'Error : weak password');
      } else if (e.code == 'invalid-email') {
        print('invalid email');
        await showErrorDialog(context, 'Error : invalid email');
      } else {
        await showErrorDialog(context, 'Error : ${e.code}');
      }
    } catch (e) {
      await showErrorDialog(context, e.toString());
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
