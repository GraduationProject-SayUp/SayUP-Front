import 'package:flutter/material.dart';
import 'service/recorder_service.dart'; // RecorderService import

class PronunciationPracticePage extends StatefulWidget {
  const PronunciationPracticePage({super.key});

  @override
  _PronunciationPracticePageState createState() =>
      _PronunciationPracticePageState();
}

class _PronunciationPracticePageState
    extends State<PronunciationPracticePage> {
  final RecorderService _recorderService = RecorderService();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  /// 녹음기 초기화
  Future<void> _initializeRecorder() async {
    try {
      await _recorderService.initializeRecorder();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('녹음기 초기화에 실패했습니다: $e')),
      );
    }
  }

  /// 녹음 상태 전환
  Future<void> _toggleRecording() async {
    try {
      if (_isRecording) {
        await _recorderService.stopRecording();
      } else {
        await _recorderService.startRecording();
      }
      setState(() {
        _isRecording = !_isRecording;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('녹음 실패: $e')),
      );
    }
  }

  @override
  void dispose() {
    _recorderService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Pronunciation',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Color(0xFF262626),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              '안녕',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    'Lip Shape Analysis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'User Lip Shape Feed Here',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 35,
              backgroundColor: _isRecording
                  ? Colors.redAccent
                  : Color(0xFF4C8BF5), // 녹음 상태에 따른 색상 변화
              child: IconButton(
                icon: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  color: Colors.white,
                ),
                iconSize: 30,
                onPressed: _toggleRecording,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Your Pronunciation Score:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  Text(
                    '85%', // 점수를 숫자로 표시
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: 0.85, // 예시 점수: 85%
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    minHeight: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                color: Color(0xFF333333),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Feedback: Your pronunciation is almost perfect! Try to focus on clearer ending sounds.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
