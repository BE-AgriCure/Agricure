import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agricare/screens/login_screen.dart';
import 'package:agricare/screens/main_tabs.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const MainTabs();
        }

        return const LoginScreen();
      },
    );
  }
}
