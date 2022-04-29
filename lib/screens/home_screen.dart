import 'package:flutter/material.dart';
import 'package:mynotes/screens/login_view.dart';
import 'package:mynotes/screens/my_notes_view.dart';
import 'package:mynotes/screens/verify_email_view.dart';
import 'package:mynotes/services/auth/auth_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            print(AuthService.firebase().currentUser);
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
