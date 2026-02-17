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

  // Example method to sign out
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Example method to get current user
  User? get currentUser => client.auth.currentUser;
}
