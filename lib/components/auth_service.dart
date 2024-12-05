import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Đăng nhập với Google (luôn hiển thị tùy chọn tài khoản)
  static Future<User?> signInWithGoogle() async {
    try {
      // Đăng xuất trước để buộc hiển thị hộp thoại chọn tài khoản
      await _googleSignIn.signOut();

      // Đăng nhập Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Người dùng đã hủy đăng nhập.");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Xác thực với Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Lưu thông tin người dùng vào Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
          'photoURL': user.photoURL,
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)); // Merge để tránh ghi đè
        print("Thông tin người dùng đã được lưu vào Firestore!");
      }
      return user;
    } catch (e) {
      print("Lỗi khi đăng nhập: $e");
      return null;
    }
  }

  // Đăng xuất
  static Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
