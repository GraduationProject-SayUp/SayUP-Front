import 'package:flutter/material.dart';
import 'package:sayup/service/recorder_service.dart';
import 'package:sayup/service/player_service.dart';
import 'package:sayup/service/uploader_service.dart';

import 'dart:async';

/// VoiceRecordPage: 녹음 화면
class VoiceRecordPage extends StatefulWidget {
  const VoiceRecordPage({super.key});

  @override
  VoiceRecordPageState createState() => VoiceRecordPageState();
}

class VoiceRecordPageState extends State<VoiceRecordPage> {
  final RecorderService recorderService = RecorderService();
  final PlayerService playerService = PlayerService();
  final UploaderService uploaderService = UploaderService();

  bool isRecording = false;
  bool isUploading = false;
  bool isPlaying = false;
  bool isRecordingCompleted = false; // 녹음 완료 상태
  String? filePath;
  int remainingTime = 15; // 남은 녹음 시간
  String displayText = "Record Your\nVoice"; // 화면에 표시할 텍스트
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initializeServices();
  }

  /// 녹음 및 재생기 초기화
  Future<void> initializeServices() async {
    await recorderService.initializeRecorder();
    await playerService.initializePlayer();
  }

  /// 녹음 시작
  Future<void> startRecording() async {
    setState(() {
      displayText = "가족 소개를\n해주세요";
      remainingTime = 15;
    });

    filePath = await recorderService.startRecording();
    setState(() {
      isRecording = true;
    });

    // 1초마다 타이머 작동
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime -= 1;
        });
      } else {
        _stopRecording();
      }
    });
  }

  /// 녹음 중지
  Future<void> _stopRecording() async {
    await recorderService.stopRecording();
    timer?.cancel();

    setState(() {
      isRecording = false;
      isRecordingCompleted = true; // 녹음 완료 상태 업데이트
      displayText = "녹음 완료! \n업로드 중...";
      isUploading = true;
    });

    try {
      await uploaderService.uploadFile(filePath!);
      setState(() {
        displayText = "업로드 성공! \n준비가 끝났어요";
        isUploading = false;
      });
    } catch (e) {
      setState(() {
        displayText = "업로드 실패";
        isUploading = false;
      });
      print('Upload error: $e');
    }
  }

  /// 파일 재생
  Future<void> playRecording() async {
    if (filePath == null) return;

    try {
      if (isPlaying) {
        await playerService.stop();
      } else {
        await playerService.play(filePath!, () {
          setState(() {
            isPlaying = false;
          });
        });
      }
      setState(() {
        isPlaying = !isPlaying;
      });
    } catch (e) {
      print('Playback error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Playback failed')),
      );
    }
  }

  @override
  void dispose() {
    recorderService.dispose();
    playerService.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Voice Recorder',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF262626),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                displayText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              if (isRecording)
                Text(
                  "남은 시간: $remainingTime 초",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: isRecording || isUploading ? null : startRecording,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: isRecording ? 80 : 60,
                  height: isRecording ? 80 : 60,
                  decoration: BoxDecoration(
                    color: isRecording || isUploading
                        ? Colors.grey
                        : Color(0xFF3A6FF7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.mic, color: Colors.white),
                ),
              ),
              if (isRecordingCompleted) SizedBox(height: 30),
              if (isRecordingCompleted)
                GestureDetector(
                  onTap: isUploading ? null : playRecording,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isPlaying
                          ? Colors.redAccent // 재생 중일 때 빨간색
                          : Color(0xFF3A6FF7), // 기본 파란색
                      borderRadius: BorderRadius.circular(30), // 둥근 모서리
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        isPlaying ? 'Stop Playback' : 'Play Recording',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
