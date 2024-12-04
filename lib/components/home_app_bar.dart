import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all( w * .008),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // chào tên của google của mình
              Text('Hello, ', style: TextStyle(fontSize: w * 0.080, fontWeight: FontWeight.w700),),
              Text('What do you want to cook today', style: TextStyle(color: Colors.grey, fontSize:  w * 0.04),)
            ],
          ),
          // xử lý toán tử 3 ngôi login true thì lấy cái Text và nguược lại
          // 2 thằng đó đề c nhấn được và xử lý sự kiện đăng nhập và đăng xuất
          Text(
            'Log in',
            style: TextStyle(
              color:
                const Color(0xFF8A47EB),
                fontSize:  w * 0.045,
                decoration: TextDecoration.underline,
            )
          ),
          // Text(
          //     'Log out',
          //     style: TextStyle(
          //       color:
          //       const Color(0xFF8A47EB),
          //       fontSize:  w * 0.045,
          //       decoration: TextDecoration.underline,
          //     )
          // ),
        ],
      ),
    );
  }
}
