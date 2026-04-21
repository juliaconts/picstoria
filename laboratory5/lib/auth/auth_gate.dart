import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laboratory5/frontend/screens/login_screen.dart';
import 'package:laboratory5/frontend/widgets/navigation_bar.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MainNavigation();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
