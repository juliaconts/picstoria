import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:laboratory5/auth/auth_gate.dart';
import 'package:laboratory5/frontend/theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyPhotoDiary());
}

class MyPhotoDiary extends StatelessWidget {
  const MyPhotoDiary({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Picstoria',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    home: const AuthGate(),
  );
}
