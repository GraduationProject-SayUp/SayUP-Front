import 'package:flutter/material.dart';

void main() {
  runApp(SayUpApp());
}

class SayUpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SayUp',
      theme: ThemeData(
        primarySwatch: Colors.blue, // 상단바 색상 테마
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SayUp'), // 상단에 앱 이름
        centerTitle: true, // 텍스트를 중앙 정렬
      ),
      backgroundColor: Color(0xFFD1D3D8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고 이미지 추가
            Image.asset(
              'assets/images/SayUP_logo.png', // 이미지 경로
              height: 300, // 로고 이미지의 크기
            ),

            SizedBox(height: 40), // 로고와 버튼 사이 간격

            ElevatedButton(
              onPressed: () {
                // 음성 모드 버튼 클릭 시 실행할 동작
                print('음성 모드 선택됨');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                'Voice',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // 글씨 두껍게
                  fontSize: 20, // 글씨 크기 키우기
                ),
              ),
            ),

            SizedBox(height: 20), // 버튼 사이 간격

            ElevatedButton(
              onPressed: () {
                // 텍스트 모드 버튼 클릭 시 실행할 동작
                print('텍스트 모드 선택됨');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                'Text',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // 글씨 두껍게
                  fontSize: 20, // 글씨 크기 키우기
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
