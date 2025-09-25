import 'package:chronolift/services/global_user_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chronolift/auth/auth_service.dart';
import 'package:chronolift/auth/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    try {
      final authService = AuthService();
      final response = await authService.registerWithEmail(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );

      if (!mounted) return;

      // Check if email confirmation is required
      if (response.user != null && response.user!.emailConfirmedAt == null) {
        // Email confirmation required
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Please check your email and click the confirmation link to complete registration.'),
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        if (response.user != null) {
          // Add user to local Drift db
          await _addUserToLocalDatabase(response.user!);

          // Registration successful and user is signed in
          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Account created. You are now signed in.')),
            );
          }
        }
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_friendlyError(e))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An unexpected error occurred: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(AuthException e) {
    switch (e.message.toLowerCase()) {
      case 'user already registered':
      case 'email address already in use':
        return 'An account already exists for that email.';
      case 'invalid email':
      case 'unable to validate email address: invalid format':
        return 'That email looks invalid.';
      case 'password is too weak':
      case 'password should be at least 6 characters':
        return 'Password must be at least 6 characters long.';
      case 'signup is disabled':
        return 'New registrations are currently disabled.';
      default:
        return e.message.isNotEmpty
            ? e.message
            : 'Registration failed. Please try again.';
    }
  }

  Future<void> _addUserToLocalDatabase(User supabaseUser) async {
    try {
      //
      await globalUser.upsertUser(
        uuid: supabaseUser.id,
        email: supabaseUser.email!,
        setAsCurrent: true,
      );
    } catch (e) {
      // Handle duplicate entry or other database errors
      if (!e.toString().contains('UNIQUE constraint failed')) {
        rethrow; // Re-throw other errors
      } 
      // User already exists otherwise
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirmCtrl,
                      obscureText: _obscure,
                      decoration: const InputDecoration(
                        labelText: 'Confirm password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v != _passwordCtrl.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _register(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _register,
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Create account'),
                      ),
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
