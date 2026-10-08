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

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _error = 'Add your email above and a reset link will go there.';
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
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        // same message whether or not the account exists,
        // so the screen never reveals which emails are registered
        setState(
          () => _notice =
              "If there's an account for that email, a reset link is on "
              'its way. Check your inbox.',
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Reset error: ${e.code}');
      if (mounted) setState(() => _error = _messageFor(e.code));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Anonymous account - no email or password needed.
  // Gets a real user ID, so data saves normally.
  // An email can be linked later to keep the same account (and its data),
  // that way a user can use TTM before committing to an account.
  Future<void> _continueWithoutAccount() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _notice = null;
    });

    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      debugPrint('Anonymous sign-in error: ${e.code}');
      if (mounted) setState(() => _error = _messageFor(e.code));
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

  // build
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Brand mark
                    Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: AppColors.sageMist,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.eco_rounded,
                          color: AppColors.sageDark,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Track That Money',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your money. No judgement.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 32),

                    // Mode title
                    Text(
                      _isSignIn ? 'Welcome back' : 'Create your account',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextField(
                      controller: _emailController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 12),

                    // Password
                    TextField(
                      controller: _passwordController,
                      enabled: !_isLoading,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      enableSuggestions: false,
                      autofillHints: [
                        _isSignIn
                            ? AutofillHints.password
                            : AutofillHints.newPassword,
                      ],
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        helperText: _isSignIn ? null : 'At least 6 characters',
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                    ),

                    // Messages
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      _MessageBox(message: _error!, isCaution: true),
                    ],
                    if (_notice != null) ...[
                      const SizedBox(height: 16),
                      _MessageBox(message: _notice!, isCaution: false),
                    ],
                    const SizedBox(height: 20),

                    // Primary action
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.sageDark,
                              ),
                            )
                          : Text(_isSignIn ? 'Sign in' : 'Create account'),
                    ),

                    // Password reset (sign-in mode only)
                    if (_isSignIn) ...[
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: _isLoading ? null : _resetPassword,
                        child: const Text('Forgot your password?'),
                      ),
                    ],
                    const SizedBox(height: 8),

                    // Switch between sign in and create account
                    TextButton(
                      onPressed: _isLoading ? null : _toggleMode,
                      child: Text(
                        _isSignIn
                            ? 'New here? Create an account'
                            : 'Already have an account? Sign in',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // No-account option
                    OutlinedButton(
                      onPressed: _isLoading ? null : _continueWithoutAccount,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.sageDark,
                        side: const BorderSide(color: AppColors.warmLinen),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ) ,
                      child: const Text('Start without an account'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You can add an email later to keep your entries safe '
                      'if you switch phones.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(color: AppColors.inkMuted),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Inline message box
// liveRegion lets TalkBack announce the message when it appears.
class _MessageBox extends StatelessWidget {
  final String message;
  final bool isCaution;

  const _MessageBox({required this.message, required this.isCaution});

  @override
  Widget build(BuildContext context) {
    final accent = isCaution ? AppColors.amber : AppColors.sage;

    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isCaution
              ? AppColors.amber.withValues(alpha: .1)
              : AppColors.sageMist,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent.withValues(alpha: .5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isCaution ? Icons.info_outline : Icons.mark_email_read_outlined,
              color: isCaution ? AppColors.amber : AppColors.sageDark,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.deepMoss),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
