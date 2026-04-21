import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laboratory5/frontend/theme/app_theme.dart';
import 'package:laboratory5/frontend/widgets/app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This fetches the current user from Firebase Auth
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: TitleAppBar(title: "Picstoria"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "My Profile",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.account_circle,
                size: 100,
                color: AppTheme.inkColor,
              ),
              const SizedBox(height: 20),

              // Ternary operator to check if user exists
              user != null
                  ? Column(
                      children: [
                        Text("Logged in as:", style: TextStyle(fontSize: 16)),
                        Text(
                          user.email ?? "No Email",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "UID: ${user.uid}",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    )
                  : const Text(
                      "Not logged in!",
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // AuthGate will automatically redirect to LoginScreen once signed out
                },
                child: const Text("Sign Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
