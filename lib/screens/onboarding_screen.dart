import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meals_manager/constants/images_path.dart';
import 'package:meals_manager/screens/home.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        height: h,
        width: w,
        child: Stack(
          children: [
            // Background image
            Positioned(
              top: 0,
              child: Container(
                height: h * 0.80,
                width: w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      ImagesPath.onBoarding,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                height: h,
                width: w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF8A47EB),
                      const Color(0xFF8A47EB),
                      const Color(0xFF8A47EB).withOpacity(0.8),
                      const Color(0xFF8A47EB).withOpacity(0.2),
                      const Color(0xFFFFFFFF).withOpacity(0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              top: h * 0.42,
              child: Container(
                alignment: Alignment.center,
                width: w,
                child: Column(
                  children: [
                    const Text(
                      'Food Recipe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),),
                    SizedBox(height: h * .015,),
                    const Center(
                      child: Text(
                        'Provide over 100 recipes from diverse \n countries and cultures around \n the world.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),),
                    ),
                  ],
                ),
              )
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: h * 0.400,
                width: w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(38),
                    topLeft: Radius.circular(38)
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 18.0, right: 18.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Let cook good food',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: h * .014,),
                      const Text(
                        'Check out the app and start cooking delicious meals!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: h * .014),
                      SizedBox(
                        width: w * .9,
                        height: h * .06,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context)=> const Home()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF8A47EB), width: 2),
                            backgroundColor: Colors.transparent,
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: h * .016,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: h * .001,
                            width: w * .33,
                            color: Colors.black,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Or',
                              style: TextStyle(color: Colors.black, fontSize: 18),
                            ),
                          ),
                          Container(
                            height: h * .001,
                            width: w * .33,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      SizedBox(height: h * .016,),
                      SizedBox(
                        width: w * .88,
                        height: h * .06,
                        child: ElevatedButton(
                          onPressed: (){
                            // mốt làm
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8A47EB),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                            )
                          ),
                          child: const Text(
                            'Sign up with google',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),
                          )),
                      ),
                      SizedBox(height: h * .016,),
                      SizedBox(
                        child: RichText(
                          text: TextSpan(
                            text: "Already have account? ",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: "Log In",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // mốt xử lý sự kiện
                                  },
                              ),
                            ],
                          ),
                        )
                      )
                    ],
                  ),
                ),
             )
            )
          ],
        ),
      ),
    );
  }
}
