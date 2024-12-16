import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// 녹음 관련 기능을 제공하는 서비스
class RecorderService {
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  String? filePath;
  bool _isInitialized = false;

  // 녹음기 초기화
  Future<void> initializeRecorder() async {
    // 마이크 권한 요청
    if (await requestMicrophonePermission() == false) {
      throw Exception('마이크 권한이 필요합니다.');
    }

    await recorder.openRecorder();
    _isInitialized = true; // 초기화 상태 설정
  }

  // 마이크 권한 요청 메서드
  Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // 권한이 거부되었거나 영구적으로 거부된 경우
      return false;
    }
    return false;
  }

  // 녹음 시작
  Future<String?> startRecording() async {
    if (!_isInitialized) {
      throw Exception('녹음기가 초기화되지 않았습니다.');
    }

    final directory = await getApplicationDocumentsDirectory();
    filePath = '${directory.path}/recorded_audio.wav'; // 저장될 경로
    print('Recording to: $filePath'); // 경로 로그 추가
    await recorder.startRecorder(toFile: filePath);
    return filePath;
  }

  // 녹음 중지 및 파일 경로 반환
  Future<String?> stopRecording() async {
    if (!_isInitialized || !recorder.isRecording) {
      throw Exception('녹음이 진행 중이 아닙니다.');
    }

    // stopRecorder() 메서드가 파일 경로를 반환합니다.
    final String? recordedFilePath = await recorder.stopRecorder();

    if (recordedFilePath == null) {
      throw Exception('녹음 중지 실패');
    }
    print('Recording to2: $filePath'); // 경로 로그 추가
    return filePath;
  }

  // 리소스 해제
  Future<void> dispose() async {
    if (_isInitialized) {
      await recorder.closeRecorder();
      _isInitialized = false;
    }
  }
}
