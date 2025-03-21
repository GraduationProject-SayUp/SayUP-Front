import 'package:flutter/material.dart';

class RoleplayPage extends StatelessWidget {
  const RoleplayPage({super.key});


  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  centerTitle: false,
  title: Text(
  'Roleplay',
  style: TextStyle(
  color: Color(0xFF6C63FF), // 보라색 텍스트
  fontSize: 22,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.2
  ),
  ),
  iconTheme: IconThemeData(color: Color(0xFF6C63FF)), // 보라색 아이콘
  leading: IconButton(
  icon: Icon(Icons.arrow_back_ios, color: Color(0xFF6C63FF)), // 보라색 아이콘
  onPressed: () => Navigator.pop(context),
  ),
  ),
  backgroundColor: Color(0xFFF5F5F5), // 밝은 회색 배경
  body: SafeArea(
  child: Column(
  children: [
  Expanded(
  flex: 7,  // 사용자 비디오가 차지하는 공간을 늘림
  child: Container(
  margin: const EdgeInsets.all(8),
  decoration: BoxDecoration(
  color: Colors.white, // 흰색 배경
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
  BoxShadow(
  color: Colors.black.withOpacity(0.1), // 부드러운 그림자
  spreadRadius: 2,
  blurRadius: 6,
  offset: Offset(0, 3),
  )
  ]
  ),
  child: Center(child: Text("User Video", style: TextStyle(color: Color(0xFF333333)))),
  ),
  ),
  Expanded(
  flex: 3,  // AI 비디오 공간 축소
  child: Container(
  margin: const EdgeInsets.all(8),
  decoration: BoxDecoration(
  color: Colors.white, // 흰색 배경
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
  BoxShadow(
  color: Colors.black.withOpacity(0.1), // 부드러운 그림자
  spreadRadius: 2,
  blurRadius: 6,
  offset: Offset(0, 3),
  )
  ]
  ),
  child: Center(child: Text("AI Video", style: TextStyle(color: Color(0xFF333333)))),
  ),
  ),
  Container(
  color: Colors.white, // 흰색 배경
  padding: const EdgeInsets.all(16),
  child: Text("AI Feedback: Positive", style: TextStyle(color: Color(0xFF00BFA5), fontSize: 18)),
  ),
  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  child: ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
  backgroundColor: Color(0xFF6C63FF), // 보라색 버튼
  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
  shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(30),
  ),
  ),
  child: Text('Start Analysis', style: TextStyle(fontSize: 18, color: Colors.white)),
  ),
  ),
  ],
  ),
  ),
  );
  }
  }



