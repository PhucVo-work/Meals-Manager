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
              Text('Hello', style: TextStyle(fontSize: w * 0.08 , fontWeight: FontWeight.w700),),
              Text('What do you want to cook today', style: TextStyle(color: Colors.grey, fontSize:  w * 0.045),)
            ],
          ),
          const Icon(CupertinoIcons.profile_circled, size: 45,)
        ],
      ),
    );
  }
}
