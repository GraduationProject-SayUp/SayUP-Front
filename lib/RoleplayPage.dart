import 'package:flutter/material.dart';

class RoleplayPage extends StatelessWidget {
  const RoleplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Roleplay',
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Color(0xFF262626),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 7,  // 사용자 비디오가 차지하는 공간을 늘림
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ]
                ),
                child: Center(child: Text("User Video", style: TextStyle(color: Colors.white))),
              ),
            ),
            Expanded(
              flex: 3,  // AI 비디오 공간 축소
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ]
                ),
                child: Center(child: Text("AI Video", style: TextStyle(color: Colors.white))),
              ),
            ),
            Container(
              color: Color(0xFF333333),
              padding: const EdgeInsets.all(16),
              child: Text("AI Feedback: Positive", style: TextStyle(color: Colors.greenAccent, fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3A6FF7),
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
