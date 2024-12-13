import 'package:flutter_sound/flutter_sound.dart';

/// 재생 관련 기능을 제공하는 서비스
class PlayerService {
  final FlutterSoundPlayer player = FlutterSoundPlayer();

  Future<void> initializePlayer() async {
    await player.openPlayer();
  }

  // 파일 재생
  Future<void> play(String filePath, void Function() onFinished) async {
    await player.startPlayer(
      fromURI: filePath,
      whenFinished: onFinished,
    );
  }

  // 재생 중지
  Future<void> stop() async {
    await player.stopPlayer();
  }

  // 재생기 리소스 해제
  Future<void> dispose() async {
    await player.closePlayer();
  }
}
