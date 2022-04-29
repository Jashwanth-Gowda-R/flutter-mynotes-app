import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_services.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  void sendVerificationLink() async {
    // final user = FirebaseAuth.instance.currentUser;
    // await user?.sendEmailVerification();
    await AuthService.firebase().sendEmailverification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
              child: Text(
                  'we have sent a email verification. Please open it to verify your account')),
          const Center(
              child: Text(
                  'If you haven\'t received verification email yet, click the below button to get verification link to your email id')),
          Center(
            child: TextButton(
              onPressed: () {
                sendVerificationLink();
              },
              child: const Text('Click to Send Verification Link'),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () async {
                // await FirebaseAuth.instance.signOut();
                await AuthService.firebase().logOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Restart'),
            ),
          )
        ],
      ),
    );
  }
}
