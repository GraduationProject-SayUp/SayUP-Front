import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = FlutterSecureStorage();

  final String _baseLoginUrl = 'http://10.0.2.2:8080/api/auth/login';
  final String _baseRegisterUrl = 'http://10.0.2.2:8080/api/auth/register';
  final String _baseLogoutUrl = 'http://10.0.2.2:8080/api/auth/logout';

  /// 로그인 메서드
  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(_baseLoginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];

      // 토큰을 안전하게 저장
      await storage.write(key: 'authToken', value: token);

      return token;
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

  /// 로그아웃 메서드
  Future<bool> logout() async {
    try {
      // 저장된 토큰 불러오기
      final String? token = await storage.read(key: 'authToken');

      if (token == null) {
        // 토큰이 없으면 이미 로그아웃 상태로 간주
        return true;
      }

      // 로그아웃 요청
      final response = await http.post(
        Uri.parse(_baseLogoutUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // 로그아웃 성공: 토큰 삭제
        await storage.delete(key: 'authToken');
        return true;
      } else {
        throw Exception('Logout failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error during logout: $e');
    }
  }
}
