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
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Add your email and password to continue.';
        _notice = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _notice = null;
    });

    try {
      if (_isSignIn) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      // Lets password managers offer to save the credentials
      TextInput.finishAutofillContext();
    } on FirebaseAuthException catch (e) {
      debugPrint('Auth error: ${e.code}');
      if (mounted) setState(() => _error = _messageFor(e.code));
    } catch (e) {
      debugPrint('Auth error: $e');
      if (mounted) {
        setState(() => _error = "That didn't go through. Want to try again?");
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Firebase error codes
  // Plain, non-judgmental tone, guidance
  String _messageFor(String code) {
    switch (code) {
      case 'invalid-email':
        return "That email doesn't look quite right. Try checking it again.";
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return "The email and password does not match. Try again, or reset "
            'your password below.';
      case 'email-already-in-use':
        return "There is already an account with that email. Try signing in "
            'instead.';
      case 'weak-password':
        return "That password is a little short. Use at least 6 characters.";
      case 'too-many-requests':
        return "Lots of attempts in a row. Please try again in a few minutes.";
      case 'network-request-failed':
        return "Couldn't connect. Check your internet and try again.";
      default:
        return "That didn't go through. Want to try again?";
    }
  }

  // build(todo)
}
