import 'package:flutter/material.dart';
import 'VoiceRecord.dart'; // 녹음 페이지 import
import 'Chatting.dart'; // 채팅 페이지 import
import 'MyPage.dart'; // 마이페이지 import
import 'RoleplayPage.dart'; // 롤플레이 import
import 'PronunciationPage.dart'; // 발음 연습 페이지 import

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Dashboard',
          style: TextStyle(
              color: Color(0xFF6C63FF), // 보라색 텍스트
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF6C63FF)), // 보라색 아이콘
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Color(0xFFF5F5F5), // 밝은 회색 배경
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStyledButton(
                context,
                text: "Go to Voice Recorder",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VoiceRecordPage()),
                  );
                }
            ),
            const SizedBox(height: 20),
            _buildStyledButton(
                context,
                text: "Go to Chat",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChattingPage()),
                  );
                }
            ),
            const SizedBox(height: 20),
            _buildStyledButton(
                context,
                text: "Go to Pronunciation",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PronunciationPracticePage()),
                  );
                }
            ),
            const SizedBox(height: 20),
            _buildStyledButton(
              context,
              text: "Go to Roleplay",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RoleplayPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledButton(BuildContext context, {required String text, required VoidCallback onPressed}) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF00BFA5)], // 그라데이션 색상 변경
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // 더 부드러운 그림자
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5
          ),
        ),
      ),
    );
  }
}

