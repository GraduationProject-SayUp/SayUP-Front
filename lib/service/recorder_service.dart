import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

/// 녹음 관련 기능을 제공하는 서비스
class RecorderService {
  final FlutterSoundRecorder recorder = FlutterSoundRecorder();
  String? filePath;

  // 녹음기 초기화
  Future<void> initializeRecorder() async {
    await recorder.openRecorder();
  }

  // 녹음 시작
  Future<String?> startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    filePath = '${directory.path}/recorded_audio.wav'; // 저장될 경로
    await recorder.startRecorder(toFile: filePath);
    return filePath;
  }

  // 녹음 중지
  Future<void> stopRecording() async {
    await recorder.stopRecorder();
  }

  Future<void> dispose() async {
    await recorder.closeRecorder();
  }
}
