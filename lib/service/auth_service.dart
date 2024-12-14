import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseLoginUrl = 'http://10.0.2.2:8080/api/auth/login';
  final String _baseRegisterUrl = 'http://10.0.2.2:8080/api/auth/register';

  /// 로그인 메서드
  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(_baseLoginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      return responseData['token'];
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  /// 회원가입 메서드
  Future<bool> register(String email, String password) async {
    final response = await http.post(
      Uri.parse(_baseRegisterUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }
}
