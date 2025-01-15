import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user; // Để lưu trữ thông tin người dùng khi đăng nhập

  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  Future<void> syncHiveBox() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;
      final userRecipesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('recipes');

      try {
        // Lấy dữ liệu từ Firestore
        final querySnapshot = await userRecipesRef.get();
        final box = await Hive.openBox('Save');

        // Tạo một danh sách chứa tất cả công thức từ Firestore
        final List<Map<String, dynamic>> recipes = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id, // Bao gồm cả ID nếu cần
            ...data, // Thêm các thuộc tính từ Firestore
          };
        }).toList();

        // Xóa dữ liệu cũ trong Hive box
        await box.clear();

        // Ghi đè danh sách mới từ Firestore vào Hive box 'Save'
        await box.put('recipes', recipes);

        print('Đồng bộ Hive box "Save" với Firestore thành công.');
      } catch (e) {
        print('Lỗi khi đồng bộ Hive box "Save": $e');
      }
    } else {
      print('Người dùng chưa đăng nhập, không thực hiện đồng bộ Hive box.');
    }
  }

  // Kiểm tra trạng thái đăng nhập của người dùng
  Future<void> _checkUserLoginStatus() async {
    _user = _auth.currentUser; // Kiểm tra người dùng đã đăng nhập chưa
    setState(() {});
  }

  // Hàm xử lý đăng nhập Google
  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Người dùng huỷ đăng nhập
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential); // Đăng nhập vào Firebase
      _checkUserLoginStatus(); // Kiểm tra lại trạng thái sau khi đăng nhập
    } catch (e) {
      print("Lỗi khi đăng nhập: $e");
    }
  }

  // Hàm xử lý đăng xuất
  Future<void> _handleSignOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _checkUserLoginStatus(); // Cập nhật trạng thái đăng nhập
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(w * .008),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${_user != null ? _user!.displayName : ""}',
                style: TextStyle(fontSize: w * 0.065, fontWeight: FontWeight.w700),
              ),
              Text(
                'What do you want to cook today',
                style: TextStyle(color: Colors.grey, fontSize: w * 0.04),
              ),
            ],
          ),
          // Xử lý dropdown menu cho icon
          PopupMenuButton<String>(
            icon: _user != null && _user!.photoURL != null
                ? CircleAvatar(
                  radius: w * 0.065,
                  backgroundImage: NetworkImage(_user!.photoURL!),
            )
                : Icon(
              _user == null
                  ? Icons.login // Biểu tượng login
                  : CupertinoIcons.person_circle_fill, // Biểu tượng account mặc định
              size: w * 0.08,
              color: const Color(0xFF8A47EB),
            ),
            onSelected: (String value) {
              if (value == 'sign_out') {
                _handleSignOut(); // Đăng xuất khi chọn "Sign out"
              } else {
                _handleGoogleSignIn(); // Đăng nhập khi chọn "Log in"
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                if (_user != null)
                  PopupMenuItem<String>(
                    value: 'sign_out',
                    child: const Text('Sign out'),
                  ),
                if (_user == null)
                  PopupMenuItem<String>(
                    value: 'sign_in',
                    child: const Text('Log in'),
                  ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
