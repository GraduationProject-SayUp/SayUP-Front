import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
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
        scaffoldBackgroundColor: const Color(0xFF262626),
      ),
      home: const VoiceRecordPage(),
    );
  }
}

// VoiceRecordPage: 녹음 화면
class VoiceRecordPage extends StatefulWidget {
  const VoiceRecordPage({super.key});

  @override
  VoiceRecordPageState createState() => VoiceRecordPageState();
}

class VoiceRecordPageState extends State<VoiceRecordPage> {
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer player = FlutterSoundPlayer();
  bool isRecording = false;
  bool isUploading = false;
  bool isPlaying = false;
  bool isRecordingCompleted = false;  // 녹음 완료 상태
  String? filePath;
  Timer? timer;
  int remainingTime = 15; // 남은 녹음 시간
  String displayText = "Record Your\nVoice";  // 화면에 표시할 텍스트

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  // 녹음기 초기화
  Future<void> initRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission denied')),
      );
      return;
    }

    try {
      await recorder.openRecorder();
      await recorder.setSubscriptionDuration(Duration(milliseconds: 500));
      await player.openPlayer();
    } catch (e) {
      print('Recorder initialization error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize recorder')),
      );
    }
  }

  // 녹음 시작
  Future<void> startRecording() async {
    setState(() {
      displayText = "가족 소개를\n해주세요";
      remainingTime = 15;
    });

    final directory = await getApplicationDocumentsDirectory();
    filePath = '${directory.path}/recorded_audio.wav'; // 저장될 경로
    try {
      await recorder.startRecorder(toFile: filePath);

      setState(() {
        isRecording = true;
      });

      timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        if (remainingTime > 0) {
          setState(() {
            remainingTime -= 1;
          });
        } else {
          _stopRecording();
        }
      });
    } catch (e) {
      setState(() {
        displayText = "녹음 시작 실패";
      });
      print('Recording error: $e');
    }
  }

  // 녹음 중지
  Future<void> _stopRecording() async {
    try {
      await recorder.stopRecorder();
    } catch (e) {
      print('Stop recording error: $e');
    }
    timer?.cancel();

    setState(() {
      isRecording = false;
      isRecordingCompleted = true;  // 녹음 완료 상태 업데이트
      displayText = "녹음 완료! \n업로드 중...";
      isUploading = true;
    });

    try {
      await _uploadAudioFile();
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

  Future<void> _uploadAudioFile() async {
    if (filePath == null) return;

    var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/upload') // 안드로이드 에뮬레이터용 localhost 주소
    );

    request.files.add(
        await http.MultipartFile.fromPath(
            'file',
            filePath!,
            filename: 'recorded_audio.wav'
        )
    );

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Upload failed');
    }
  }

  Future<void> playRecording() async {
    if (filePath == null) return;

    try {
      if (isPlaying) {
        await player.stopPlayer();
      } else {
        await player.startPlayer(
          fromURI: filePath,
          whenFinished: () {
            setState(() {
              isPlaying = false;
            });
          },
        );
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
    recorder.closeRecorder();
    timer?.cancel(); // 타이머 해제
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
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Color(0xFF262626),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 상태 텍스트
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
              // 남은 시간 텍스트
              if (isRecording)
                Text(
                  "남은 시간: $remainingTime 초",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              SizedBox(height: 50),
              // 녹음 버튼
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.mic,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              // 녹음이 완료된 경우에만 재생 버튼 표시
              if (isRecordingCompleted)
                SizedBox(height: 20),
              if (isRecordingCompleted)
                ElevatedButton(
                  onPressed: isUploading ? null : playRecording,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                      isPlaying ? Colors.redAccent : Color(0xFF3A6FF7),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isPlaying ? 'Stop Playback' : 'Play Recording',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}