import 'package:flutter/material.dart';
import 'VoiceRecord.dart'; // 녹음 페이지 import
import 'Chatting.dart'; // 채팅 페이지 import

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"), // Dashboard 타이틀 설정
        backgroundColor: Colors.black, // AppBar 배경색 검정으로 설정
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
          children: [
            ElevatedButton(
              onPressed: () {
                // 녹음 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VoiceRecordPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // 버튼 배경색 검정으로 설정
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // 버튼 패딩 설정
                shape: RoundedRectangleBorder( // 버튼 모서리 둥글게 설정
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Go to Voice Recorder", // 음성 녹음 페이지로 이동하는 버튼 텍스트
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20), // 버튼 사이의 간격 추가
            ElevatedButton(
              onPressed: () {
                // 채팅 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChattingPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // 버튼 배경색 검정으로 설정
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // 버튼 패딩 설정
                shape: RoundedRectangleBorder( // 버튼 모서리 둥글게 설정
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Go to Chat", // 채팅 페이지로 이동하는 버튼 텍스트
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}