import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chronolift/auth/auth_service.dart';
import 'package:chronolift/auth/validators.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();


  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    try {
      final authService = AuthService();
      await authService.signInWithEmailAndSetUser(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      if (!mounted) return;

      // AuthGate stream will navigate to Home automatically.
    } on AuthException catch (e) {
      _showError(_friendlyError(e));
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailCtrl.text.trim();
    if (Validators.email(email) != null) {
      _showError('Enter a valid email to reset password.');
      return;
    }
    setState(() => _loading = true);
    try {
      final authService = AuthService();
      await authService.sendPasswordReset(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent. Check your inbox.'),
          duration: Duration(seconds: 4),
        ),
      );
    } on AuthException catch (e) {
      _showError(_friendlyError(e));
    } catch (e) {
      _showError('Failed to send reset email. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('invalid login credentials') ||
        message.contains('email not confirmed') ||
        message.contains('invalid email or password')) {
      return 'Invalid email or password.';
    }

    switch (message) {
      case 'invalid email':
      case 'unable to validate email address: invalid format':
        return 'That email looks invalid.';
      case 'user not found':
      case 'email not found':
        return 'No user found with that email.';
      case 'invalid password':
      case 'wrong password':
        return 'Incorrect password.';
      case 'too many requests':
      case 'rate limit exceeded':
        return 'Too many attempts. Try again later.';
      case 'user disabled':
      case 'account disabled':
        return 'This account has been disabled.';
      case 'email not confirmed':
        return 'Please confirm your email before signing in.';
      case 'signup disabled':
        return 'Sign-in is currently disabled.';
      default:
        return e.message.isNotEmpty
            ? e.message
            : 'Sign-in failed. Please try again.';
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  Icon(Icons.fitness_center, size: 72, color: cs.primary),
                  const SizedBox(height: 16),
                  Text(
                    'ChronoLift',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track your lifts. Crush your goals.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.tertiary.withValues(alpha: 0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.username],
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          validator: Validators.email,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: _obscure,
                          autofillHints: const [AutofillHints.password],
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: Validators.password,
                          onFieldSubmitted: (_) => _login(),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _loading ? null : _forgotPassword,
                            child: const Text('Forgot password?'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _login,
                            child: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Log in'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        onPressed: _loading ? null : _goToRegister,
                        child: const Text(
                          'Register',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
