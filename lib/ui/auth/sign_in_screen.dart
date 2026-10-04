import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/colors.dart';

/// Track That Money
/// lib/ui/auth/sign_in_screen.dart
/// Email/password sign-in and account creation via Firebase auth.
/// This screen never navigates on its own: the GoRouter redirect
/// in app.dart moves the user to the dashboard once they're signed in.

enum _Mode { signIn, createAccount }

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  _Mode _mode = _Mode.signIn;
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Caution message (amber)
  // something needs the user's attention
  String? _error;
  // Neutral message (sage)
  // example: reset email sent
  String? _notice;

  bool get _isSignIn => _mode == _Mode.signIn;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _mode = _isSignIn ? _Mode.createAccount : _Mode.signIn;
      _error = null;
      _notice = null;
    });
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    
  }
}
