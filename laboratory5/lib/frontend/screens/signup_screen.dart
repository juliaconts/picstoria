import 'package:flutter/material.dart';
import 'package:laboratory5/frontend/theme/app_theme.dart';
import 'package:laboratory5/auth/auth_gate.dart';
import 'package:laboratory5/backend/services/auth_service.dart';
import 'package:laboratory5/frontend/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); // NEW
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // IMPORTANT: Clean up controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create a new account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (value) =>
                          (value == null || !value.contains('@'))
                          ? 'Please enter a valid email'
                          : null,
                    ),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: "Password"),
                      obscureText: true,
                      validator: (value) => (value == null || value.length < 6)
                          ? 'Must be at least 6 characters'
                          : null,
                    ),

                    // Confirm Password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: "Confirm Password",
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await _authService.signUp(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );

                            if (!mounted) return;

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AuthGate(),
                              ),
                              (route) => false,
                            );
                            // No manual navigation needed! AuthGate will catch the change.
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Signup failed: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text("Sign Up"),
                    ),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: AppTheme.accentColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
