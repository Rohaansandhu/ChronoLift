import 'package:chronolift/pages/main_navbar_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chronolift/pages/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Loading state while Supabase checks auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check if we have auth data
        final authState = snapshot.data;
        final user = authState?.session?.user;

        // Logged in and email is confirmed (if email confirmation is required)
        if (user != null) {
          // Optional: Check if email confirmation is required
          // If your Supabase project requires email confirmation, uncomment this:
          // if (user.emailConfirmedAt == null) {
          //   return const EmailConfirmationPage();
          // }
          
          return const MainNavPage();
        }

        // Not logged in
        return const LoginPage();
      },
    );
  }
}