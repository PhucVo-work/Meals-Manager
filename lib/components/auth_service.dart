// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
// class AuthService {
//   static final FirebaseAuth _auth = FirebaseAuth.instance;
//   static final GoogleSignIn _googleSignIn = GoogleSignIn();
//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Thêm Firestore
//   // Hàm đăng nhập bằng Google
//   static Future<User?> signInWithGoogle() async {
//     try {
//       // Đăng nhập bằng Google và yêu cầu người dùng chọn tài khoản
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn(); // Đây là bước yêu cầu người dùng chọn tài khoản
//       if (googleUser == null) {
//         // Người dùng hủy đăng nhập
//         return null;
//       }
//
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//       // Tạo credential
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       // Đăng nhập vào Firebase
//       final UserCredential userCredential = await _auth.signInWithCredential(credential);
//
//       return userCredential.user;
//     } catch (e) {
//       print("Lỗi khi đăng nhập: $e");
//       return null;
//     }
//   }
//
//   // Lưu người dùng vào Firestore
//   static Future<void> _saveUserToFirestore(User user) async {
//     final DocumentReference userDoc = _firestore.collection('users').doc(user.uid);
//
//     // Kiểm tra xem document đã tồn tại chưa
//     final DocumentSnapshot userSnapshot = await userDoc.get();
//     if (!userSnapshot.exists) {
//       // Tạo mới document nếu chưa tồn tại
//       await userDoc.set({
//         'uid': user.uid,
//         'email': user.email,
//         'displayName': user.displayName,
//         'photoURL': user.photoURL,
//         'createdAt': FieldValue.serverTimestamp(),
//         'lastLogin': FieldValue.serverTimestamp(),
//       });
//     } else {
//       // Cập nhật `lastLogin` nếu document đã tồn tại
//       await userDoc.update({
//         'lastLogin': FieldValue.serverTimestamp(),
//       });
//     }
//   }
//
//   // Hàm đăng xuất
//   static Future<void> signOut() async {
//     await _auth.signOut();
//     await _googleSignIn.signOut();
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Thêm Firestore

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

      // Kiểm tra nếu người dùng đăng nhập thành công và lưu thông tin vào Firestore
      final User? user = userCredential.user;
      if (user != null) {
        // Lưu hoặc cập nhật người dùng vào Firestore
        await _saveUserToFirestore(user);
      }

      return user;
    } catch (e) {
      print("Lỗi khi đăng nhập: $e");
      return null;
    }
  }

  static Future<void> _saveUserToFirestore(User user) async {
    try {
      // Lấy tham chiếu tới tài liệu của người dùng
      final DocumentReference userDoc = _firestore.collection('users').doc(user.uid);

      // Kiểm tra nếu tài liệu không tồn tại thì tạo mới
      final DocumentSnapshot userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        // Tạo tài liệu mới cho người dùng
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
        print("Tạo tài liệu mới thành công cho người dùng: ${user.email}");
      } else {
        // Nếu tài liệu đã tồn tại, cập nhật thời gian đăng nhập cuối cùng
        await userDoc.update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
        print("Cập nhật thời gian đăng nhập cuối cùng cho người dùng: ${user.email}");
      }
    } catch (e) {
      print("Lỗi khi lưu dữ liệu người dùng vào Firestore: $e");
    }
  }


  // Hàm đăng xuất
  static Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
