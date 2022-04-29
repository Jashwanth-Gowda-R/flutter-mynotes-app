import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/screens/home_screen.dart';
import 'package:mynotes/screens/login_view.dart';
import 'package:mynotes/screens/my_notes_view.dart';
import 'package:mynotes/screens/register_view.dart';
import 'package:mynotes/screens/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    );
  }
}
