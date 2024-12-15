import 'package:flutter/material.dart';
import 'VoiceRecord.dart'; // 녹음 페이지 import
import 'Chatting.dart'; // 채팅 페이지 import
import 'MyPage.dart'; // 마이페이지 import
import 'RoleplayPage.dart'; // 롤플레이 import

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 기존 AppBar 대신 커스텀 앱바 디자인
      appBar: AppBar(
        // 배경색을 투명으로 설정
        backgroundColor: Colors.transparent,
        // 그림자 제거
        elevation: 0,
        // 앱바 제목을 가운데 정렬
        centerTitle: true,
        // 앱바 타이틀 스타일링
        title: Text(
          'Dashboard',
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2
          ),
        ),
        // 앱바 아이콘 테마 설정
        iconTheme: IconThemeData(color: Colors.white),
        // 선택적으로 오른쪽에 액션 아이콘 추가 가능
        actions: [
          IconButton(
            icon: Icon(Icons.person), // 프로필 아이콘
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 설정 페이지로 이동 또는 설정 모달 표시
            },
          ),
        ],
      ),
      // 배경색을 어두운 그레이로 변경
      backgroundColor: Color(0xFF262626),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
          children: [
            // 음성 녹음 버튼
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
            const SizedBox(height: 20), // 버튼 사이의 간격 추가
            // 채팅 버튼
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
            const SizedBox(height: 20), // 버튼 사이의 간격 추가
            // Roleplay 버튼 추가
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

  // 재사용 가능한 스타일화된 버튼 위젯
  Widget _buildStyledButton(
      BuildContext context, {
        required String text,
        required VoidCallback onPressed
      }) {
    return Container(
      width: 250, // 고정 너비
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3A6FF7), // 밝은 블루
            Color(0xFF3A6FF7).withOpacity(0.8), // 살짝 어두운 블루
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // 둥근 모서리
        borderRadius: BorderRadius.circular(15),
        // 부드러운 그림자 효과
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        // 버튼 스타일 제거 (배경색 투명)
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