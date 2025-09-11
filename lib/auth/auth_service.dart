import 'package:chronolift/services/global_user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  AuthService();

  // Stream of auth state changes
  Stream<AuthState> get authState => _supabase.auth.onAuthStateChange;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Get current session
  Session? get currentSession => _supabase.auth.currentSession;

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Legacy method name for compatibility
  Future<void> logout() => signOut();

  // Sign in with email and password
  // In AuthService
  Future<AuthResponse> signInWithEmailAndSetUser({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth
        .signInWithPassword(email: email, password: password);

    // If successful, update GlobalUserService
    if (response.user != null) {
      try {
        await globalUser.setCurrentUserByEmail(email);
      } catch (e) {
        // User doesn't exist locally, create them
        await globalUser.upsertUser(
          uuid: response.user!.id,
          email: response.user!.email!,
          setAsCurrent: true,
        );
      }
    }

    return response;
  }

  // Legacy method name for compatibility
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await signInWithEmailAndSetUser(email: email, password: password);
  }

  // Register with email and password
  Future<AuthResponse> registerWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // Send password reset email
  Future<void> sendPasswordReset({required String email}) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // Check if user's email is confirmed
  bool get isEmailConfirmed => currentUser?.emailConfirmedAt != null;

  // Resend email confirmation
  Future<void> resendEmailConfirmation() async {
    final email = currentUser?.email;
    if (email != null) {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email,
      );
    } else {
      throw Exception('No user email found');
    }
  }

  // Update user email
  Future<UserResponse> updateEmail(String newEmail) async {
    return await _supabase.auth.updateUser(
      UserAttributes(email: newEmail),
    );
  }

  // Update user password
  Future<UserResponse> updatePassword(String newPassword) async {
    return await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  // Sign in with OTP (One-Time Password)
  Future<void> signInWithOTP({required String email}) async {
    await _supabase.auth.signInWithOtp(email: email);
  }

  // Verify OTP
  Future<AuthResponse> verifyOTP({
    required String email,
    required String token,
    required OtpType type,
  }) async {
    return await _supabase.auth.verifyOTP(
      email: email,
      token: token,
      type: type,
    );
  }

  // Get user profile/metadata
  Map<String, dynamic>? get userMetadata => currentUser?.userMetadata;

  // Update user metadata
  Future<UserResponse> updateUserMetadata(Map<String, dynamic> data) async {
    return await _supabase.auth.updateUser(
      UserAttributes(data: data),
    );
  }
}
