import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async'; // 타이머 사용을 위한 import

void main() {
  runApp(const VoiceRecordApp());
}

class VoiceRecordApp extends StatelessWidget {
  const VoiceRecordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF262626),
      ),
      home: const VoiceRecordPage(),
    );
  }
}

class VoiceRecordPage extends StatefulWidget {
  const VoiceRecordPage({super.key});

  @override
  VoiceRecordPageState createState() => VoiceRecordPageState();
}

class VoiceRecordPageState extends State<VoiceRecordPage> {
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  bool isRecording = false;
  String? filePath;
  Timer? timer; // 타이머 변수 추가
  String displayText = "Record Your\nVoice"; // 화면에 표시할 텍스트

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  // 녹음기 초기화
  Future<void> initRecorder() async {
    await recorder.openRecorder();
  }

  // 녹음 시작
  Future<void> startRecording() async {
    setState(() {
      displayText = "가족 소개를\n해주세요"; // 텍스트 변경
    });

    final directory = await getApplicationDocumentsDirectory();
    filePath = '${directory.path}/recorded_audio.wav'; // 저장될 경로
    await recorder.startRecorder(toFile: filePath);
    setState(() {
      isRecording = true;
    });

    // 15초 후에 자동으로 녹음을 멈추는 타이머 설정
    timer = Timer(Duration(seconds: 15), () {
      _stopRecording();
    });
  }

  // 녹음 중지
  Future<void> _stopRecording() async {
    await recorder.stopRecorder();
    timer?.cancel(); // 타이머 취소
    setState(() {
      isRecording = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Recording saved to $filePath')),
    );
    displayText = "준비가 모두\n끝났어요 !!";
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    timer?.cancel(); // 타이머 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(  // Scaffold에 Center 위젯으로 전체 콘텐츠 중앙 정렬
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // 세로 방향으로 중앙 정렬
            crossAxisAlignment: CrossAxisAlignment.center, // 가로 방향으로 중앙 정렬
            children: [
              // 텍스트 부분
              Text(
                displayText, // 상태에 맞는 텍스트 표시
                textAlign: TextAlign.center, // 텍스트 가운데 정렬
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 50),

              // 녹음 버튼
              ElevatedButton(
                onPressed: () {
                  if (!isRecording) {
                    startRecording();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isRecording ? 'Recording...' : 'Start Recording',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
