import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sayup/service/auth_service.dart';

class MyPage extends StatelessWidget {
  MyPage({super.key});

  final AuthService _authService = AuthService();

  /// 로그아웃 메서드
  Future<void> _logout(BuildContext context) async {
    try {
      await _authService.logout();
      // 로그인 화면으로 이동
      Navigator.pushReplacementNamed(context, '/login');
    } catch (error) {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Page',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Color(0xFF262626),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 섹션
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF3A6FF7),
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'John@example.com',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            // 메뉴 섹션
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text(
                'Settings',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white54),
              onTap: () {
                // 설정 페이지로 이동
              },
            ),
            Divider(color: Colors.white24),
            ListTile(
              leading: Icon(Icons.help_outline, color: Colors.white),
              title: Text(
                'Help',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white54),
              onTap: () {
                // 도움말 페이지로 이동
              },
            ),
            Divider(color: Colors.white24),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text(
                'Log Out',
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
              onTap: () => _logout(context), // 로그아웃 메서드 호출
            ),
          ],
        ),
      ),
    );
  }
}
