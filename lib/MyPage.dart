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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF6C63FF)), // 보라색 아이콘
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Page',
          style: TextStyle(
            color: Color(0xFF6C63FF), // 보라색 텍스트
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Color(0xFFF5F5F5), // 밝은 회색 배경
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF6C63FF), // 보라색 배경
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John',
                      style: TextStyle(
                        color: Color(0xFF333333), // 어두운 회색 텍스트
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'John@example.com',
                      style: TextStyle(
                        color: Color(0xFF666666), // 중간 회색 텍스트
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.settings, color: Color(0xFF6C63FF)), // 보라색 아이콘
              title: Text(
                'Settings',
                style: TextStyle(color: Color(0xFF333333), fontSize: 16), // 어두운 회색 텍스트
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF6C63FF)), // 보라색 아이콘
              onTap: () {},
            ),
            Divider(color: Colors.grey[300]), // 밝은 회색 구분선
            ListTile(
              leading: Icon(Icons.help_outline, color: Color(0xFF6C63FF)), // 보라색 아이콘
              title: Text(
                'Help',
                style: TextStyle(color: Color(0xFF333333), fontSize: 16), // 어두운 회색 텍스트
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF6C63FF)), // 보라색 아이콘
              onTap: () {},
            ),
            Divider(color: Colors.grey[300]), // 밝은 회색 구분선
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text(
                'Log Out',
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}


