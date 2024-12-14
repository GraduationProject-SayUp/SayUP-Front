import 'package:flutter/material.dart';
import 'package:sayup/SignUp.dart';  // 회원가입 페이지로 이동하기 위한 import
import 'package:sayup/DashboardPage.dart';
import 'package:sayup/service/auth_service.dart';
import 'package:sayup/widgets/rounded_button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Flutter Secure Storage 인스턴스 생성
final storage = FlutterSecureStorage();

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


class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;

  /// 토큰 저장 메서드
  Future<void> saveToken(String token) async {
    await storage.write(key: 'authToken', value: token);
  }

  void _performLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackBar('Please enter email and password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // 로그인 성공 시 토큰 저장
      await saveToken(token);

      setState(() {
        _isLoading = false;
      });

      // 로그인 성공: DashboardPage로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar(e.toString());
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo_grayscale_big.png"),
            const SizedBox(height: 26),
            _buildTextField(
              controller: _emailController,
              hintText: "Enter your email",
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _passwordController,
              hintText: "Enter your password",
              obscureText: true,
            ),
            const SizedBox(height: 16),
            RoundedButton(
              text: "Login",
              isLoading: _isLoading,
              onPressed: _performLogin,
            ),
            const SizedBox(height: 16),
            _buildSignUpOption(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildSignUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
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
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
