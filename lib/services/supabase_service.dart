import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart' as g_sign_in;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  final SupabaseClient client = Supabase.instance.client;

  // Example method to sign up
  Future<AuthResponse> signUp(String email, String password) async {
    return await client.auth.signUp(email: email, password: password);
  }

  // Example method to sign in
  Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Google Sign-In
  Future<AuthResponse> signInWithGoogle() async {
    /// Web Client ID that you registered with Google Cloud.
    /// This is required for Google Sign In on Android to get the idToken.
    /// You must create a "Web application" credential in Google Cloud Console
    /// and use its Client ID here.
    const webClientId =
        '98263422578-0lj6hljkb2t7te7akkia0hlak0jkl9k3.apps.googleusercontent.com';

    // Google Sign In
    final g_sign_in.GoogleSignIn googleSignIn = g_sign_in.GoogleSignIn(
      serverClientId: webClientId,
      scopes: ['email', 'profile'],
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw 'Google Sign In cancelled by user.';
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }

    if (idToken == null) {
      throw 'No ID Token found. Make sure you are using the Web Client ID on Android.';
    }

    return client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  // Example method to sign out
  Future<void> signOut() async {
    final g_sign_in.GoogleSignIn googleSignIn = g_sign_in.GoogleSignIn();
    await googleSignIn.signOut(); // Ensure Google session is also cleared
    await client.auth.signOut();
  }

  // Example method to get current user
  User? get currentUser => client.auth.currentUser;

  // Get Profile
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final userId = currentUser?.id;
      if (userId == null) return null;

      final data = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return data;
    } catch (e) {
      // debugPrint('Error fetching profile: $e');
      return null;
    }
  }

  // Update Profile
  Future<void> updateProfile({
    required String fullName,
    File? avatarFile,
    required bool isReminderEnabled,
    required String reminderTime,
  }) async {
    final userId = currentUser?.id;
    if (userId == null) throw 'User not logged in';

    final updates = {
      'id': userId,
      'full_name': fullName,
      'is_reminder_enabled': isReminderEnabled,
      'daily_reminder_time': reminderTime,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (avatarFile != null) {
      final fileExt = avatarFile.path.split('.').last;
      final fileName = '$userId-${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;

      await client.storage
          .from('avatars')
          .upload(
            filePath,
            avatarFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final imageUrl = client.storage.from('avatars').getPublicUrl(filePath);
      updates['avatar_url'] = imageUrl;
    }

    await client.from('profiles').upsert(updates);
  }
}
