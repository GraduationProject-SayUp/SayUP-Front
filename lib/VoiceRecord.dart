import 'package:flutter/material.dart';
import 'package:sayup/service/recorder_service.dart';
import 'package:sayup/service/player_service.dart';
import 'package:sayup/service/uploader_service.dart';
import 'dart:async';

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
  bool isRecordingCompleted = false;
  String? filePath;
  int remainingTime = 15;
  String displayText = "Record Your\nVoice";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initializeServices();
  }

  Future<void> initializeServices() async {
    await recorderService.initializeRecorder();
    await playerService.initializePlayer();
  }

  Future<void> startRecording() async {
    setState(() {
      displayText = "자기소개를\n해주세요";
      remainingTime = 15;
      isRecording = true;
    });

    filePath = await recorderService.startRecording();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime -= 1;
        });
      } else {
        stopRecording();
      }
    });
  }

  Future<void> stopRecording() async {
    await recorderService.stopRecording();
    timer?.cancel();

    setState(() {
      isRecording = false;
      isRecordingCompleted = true;
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
      debugPrint('Upload error: $e');
    }
  }

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
      debugPrint('Playback error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Playback failed')),
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
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
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              if (isRecording)
                Text(
                  "남은 시간: $remainingTime 초",
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: isRecording || isUploading ? null : startRecording,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isRecording ? 80 : 60,
                  height: isRecording ? 80 : 60,
                  decoration: BoxDecoration(
                    color: isRecording || isUploading
                        ? Colors.grey
                        : const Color(0xFF3A6FF7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic, color: Colors.white),
                ),
              ),
              if (isRecordingCompleted) const SizedBox(height: 30),
              if (isRecordingCompleted)
                GestureDetector(
                  onTap: isUploading ? null : playRecording,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 200,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isPlaying ? Colors.redAccent : const Color(0xFF3A6FF7),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        isPlaying ? 'Stop Playback' : 'Play Recording',
                        style: const TextStyle(
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
