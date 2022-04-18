import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  void sendVerificationLink() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: const Text('Please verify your email address')),
        Center(
          child: TextButton(
            onPressed: () {
              sendVerificationLink();
            },
            child: const Text('Click to Send Verification Link'),
          ),
        )
      ],
    );
  }
}
