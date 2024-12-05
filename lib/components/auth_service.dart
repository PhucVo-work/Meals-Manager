import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hàm đăng nhập bằng Google
  static Future<User?> signInWithGoogle() async {
    try {
      // Đăng nhập bằng Google và yêu cầu người dùng chọn tài khoản
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
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
      final User? user = userCredential.user;

      // Lưu thông tin người dùng vào Firestore
      if (user != null) {
        await _saveUserToFirestore(user);
      }

      return user;
    } catch (e) {
      print("Lỗi khi đăng nhập: $e");
      return null;
    }
  }

  // Lưu người dùng vào Firestore
  static Future<void> _saveUserToFirestore(User user) async {
    final DocumentReference userDoc = _firestore.collection('users').doc(user.uid);

    // Kiểm tra xem document đã tồn tại chưa
    final DocumentSnapshot userSnapshot = await userDoc.get();
    if (!userSnapshot.exists) {
      // Tạo mới document nếu chưa tồn tại
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'uids': [user.uid], // Mảng chứa UID, ban đầu chỉ có UID này
      });
    } else {
      // Cập nhật `lastLogin` và thêm UID vào mảng `uids` nếu document đã tồn tại
      await userDoc.update({
        'lastLogin': FieldValue.serverTimestamp(),
        'uids': FieldValue.arrayUnion([user.uid]), // Thêm UID vào mảng `uids`
      });
    }
  }

  // Hàm đăng xuất
  static Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
