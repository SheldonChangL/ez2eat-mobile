import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final _googleSignIn = GoogleSignIn(
  // Web Client ID — 在 Google Cloud Console 建立 OAuth Web Client 後填入
  clientId: kIsWeb ? 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com' : null,
);

class AuthNotifier extends Notifier<GoogleSignInAccount?> {
  @override
  GoogleSignInAccount? build() => null;

  Future<String?> signIn() async {
    if (kIsWeb) return '請在手機 App 上使用 Google 登入';
    try {
      final account = await _googleSignIn.signIn();
      state = account;
      return null;
    } catch (e) {
      return '登入失敗，請再試一次';
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    state = null;
  }
}

final authProvider = NotifierProvider<AuthNotifier, GoogleSignInAccount?>(AuthNotifier.new);
