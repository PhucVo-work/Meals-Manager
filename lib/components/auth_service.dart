import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Hàm đăng nhập bằng Google
  static Future<User?> signInWithGoogle() async {
    try {
      // Đăng nhập bằng Google và yêu cầu người dùng chọn tài khoản
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn(); // Đây là bước yêu cầu người dùng chọn tài khoản
      if (googleUser == null) {
        // Người dùng hủy đăng nhập
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Tạo credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập vào Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print("Lỗi khi đăng nhập: $e");
      return null;
    }
  }

  // Hàm đăng xuất
  static Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
