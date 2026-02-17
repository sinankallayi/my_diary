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

  // Save Diary Entry
  Future<void> saveDiaryEntry({
    required DateTime date,
    required String content,
    required List<String> imageUrls,
  }) async {
    final userId = currentUser?.id;
    if (userId == null) throw 'User not logged in';

    final dateStr = date.toIso8601String().split('T').first; // YYYY-MM-DD

    final data = {
      'user_id': userId,
      'entry_date': dateStr,
      'content': content,
      'images': imageUrls,
      'updated_at': DateTime.now().toIso8601String(),
    };

    // Check if entry exists for this date
    final existingElement = await client
        .from('diary_entries')
        .select('id')
        .eq('user_id', userId)
        .eq('entry_date', dateStr)
        .maybeSingle();

    if (existingElement != null) {
      await client
          .from('diary_entries')
          .update(data)
          .eq('id', existingElement['id']);
    } else {
      await client.from('diary_entries').insert(data);
    }
  }

  // Get Diary Entry
  Future<Map<String, dynamic>?> getDiaryEntry(DateTime date) async {
    final userId = currentUser?.id;
    if (userId == null) return null;

    final dateStr = date.toIso8601String().split('T').first;

    try {
      final data = await client
          .from('diary_entries')
          .select()
          .eq('user_id', userId)
          .eq('entry_date', dateStr)
          .maybeSingle();
      return data;
    } catch (e) {
      // debugPrint('Error fetching diary entry: $e');
      return null;
    }
  }

  // Upload Diary Image
  Future<String> uploadDiaryImage(File imageFile) async {
    final userId = currentUser?.id;
    if (userId == null) throw 'User not logged in';

    final fileExt = imageFile.path.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final filePath = '$userId/$fileName'; // Folder per user

    await client.storage
        .from('diary_images')
        .upload(
          filePath,
          imageFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    final imageUrl = client.storage.from('diary_images').getPublicUrl(filePath);
    return imageUrl;
  }

  // Get All Diary Entries (for Memories)
  Future<List<Map<String, dynamic>>> getAllDiaryEntries() async {
    final userId = currentUser?.id;
    if (userId == null) return [];

    try {
      final data = await client
          .from('diary_entries')
          .select()
          .eq('user_id', userId)
          .order('entry_date', ascending: false); // Newest first

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      // debugPrint('Error fetching all diary entries: $e');
      return [];
    }
  }

  // Get Dates with Entries (for Calendar)
  Future<List<DateTime>> getDiaryDates() async {
    final userId = currentUser?.id;
    if (userId == null) return [];

    try {
      final data = await client
          .from('diary_entries')
          .select('entry_date')
          .eq('user_id', userId);

      final List<DateTime> dates = [];
      for (var item in data) {
        if (item['entry_date'] != null) {
          dates.add(DateTime.parse(item['entry_date']));
        }
      }
      return dates;
    } catch (e) {
      // debugPrint('Error fetching diary dates: $e');
      return [];
    }
  }
}
