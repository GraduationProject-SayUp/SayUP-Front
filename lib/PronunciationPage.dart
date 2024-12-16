import 'package:flutter/material.dart';

class PronunciationPracticePage extends StatelessWidget {
  const PronunciationPracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Pronunciation Practice',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Tap the microphone to start recording your pronunciation',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          IconButton(
            iconSize: 60,
            icon: Icon(Icons.mic, color: Colors.blue),
            onPressed: () {
              // 녹음 시작 로직
            },
          ),
          SizedBox(height: 20),
          Text(
            'Your Pronunciation Score:',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.7, // 예시: 70% 정확도
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 20,
          ),
          SizedBox(height: 20),
          Text(
            'Feedback: Try to relax your tongue more',
            style: TextStyle(color: Colors.greenAccent, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
