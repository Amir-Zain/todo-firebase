import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_firebase/providers/auth_provider.dart';


class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            authProvider.loginWithGoogle();
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}