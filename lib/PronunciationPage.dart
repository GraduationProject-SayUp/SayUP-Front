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
      backgroundColor: Color(0xFF262626),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Pronunciation',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                '안녕',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 30),
              _buildLipShapeAnalysisCard(),
              const SizedBox(height: 30),
              _buildRecordingButton(),
              const SizedBox(height: 30),
              _buildPronunciationScoreCard(),
              const SizedBox(height: 20),
              _buildFeedbackCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLipShapeAnalysisCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lip Shape Analysis',
              style: TextStyle(
                color: Color(0xFF4C8BF5),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'User Lip Shape Feed Here',
                  style: TextStyle(
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingButton() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _isRecording
            ? Color(0xFFFF4E4E)  // 밝은 빨간색
            : Color(0xFF4C8BF5), // 기존 파란색
        boxShadow: [
          BoxShadow(
            color: _isRecording
                ? Color(0xFFFF4E4E).withOpacity(0.4)
                : Color(0xFF4C8BF5).withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: _toggleRecording,
          child: Center(
            child: Icon(
              _isRecording ? Icons.stop : Icons.mic,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPronunciationScoreCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Your Pronunciation Score:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              '85%',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.85,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
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
    );
  }
}