import 'package:flutter/material.dart';
import 'package:sayup/SignUp.dart';  // 회원가입 페이지로 이동하기 위한 import

void main() {
  runApp(const SignInApp());
}

class SignInApp extends StatelessWidget {
  const SignInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF262626),
      ),
      home: const SignInPage(),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);  // Key 처리

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0), // 화면 전체 여백
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. 로고 이미지
            Image(image: AssetImage("assets/images/logo-grayscale.png")),
            // 2. 이메일 입력 필드
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Enter your email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),

            // 3. 비밀번호 입력 필드
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Enter your password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),

            // 4. 로그인 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 로그인 버튼 동작
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // 5. 계정이 없나요? 회원가입과 구분선
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don’t have an account?",
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    // SignUpPage로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Text(
              "or",
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16),

            // 6. 구글로 계속하기 버튼
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // 구글 로그인 버튼 동작
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Image.asset(
                  "assets/images/google_logo.png", // 구글 로고
                  width: 24,
                  height: 24,
                ),
                label: Text(  // 'label' 필수 파라미터 추가
                  "Continue with Google",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
