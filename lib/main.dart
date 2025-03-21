import 'package:flutter/material.dart';
import 'SignIn.dart'; // SignInPage import
import 'MyPage.dart'; // MyPage import

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF5F5F5), // 밝은 회색 배경
        primaryColor: Color(0xFF6C63FF), // 보라색
        fontFamily: 'Poppins', // 폰트 설정
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoadingPage(),
        '/login': (context) => SignInPage(),
        '/mypage': (context) => MyPage(),
      },
    );
  }
}

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5), // 밝은 회색 배경
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 406,
            height: 386,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/sayup_image.jpg"),
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

