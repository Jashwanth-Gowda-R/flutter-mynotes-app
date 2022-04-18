import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/screens/login_view.dart';
import 'package:mynotes/screens/verify_email_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // print(FirebaseAuth.instance.currentUser);
            // final user = FirebaseAuth.instance.currentUser;
            // if (user?.emailVerified ?? false) {
            //   return const Text('Your a verified user');
            // } else {
            //   print('You need to verify your email id ');
            //   return VerifyEmailView();
            // }
            return LoginView();
          default:
            return const CircularProgressIndicator();
        }
      },
    ) ;
  }
}
