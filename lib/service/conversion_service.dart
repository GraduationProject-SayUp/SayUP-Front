import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ConversionService {
  final String apiURL = 'http://10.0.0.2:8080/api/voice/conversion';

  // 텍스트를 서버로 보내고 오디오 파일을 받아오는 함수
  Future<File?> convertTextToVoice({
    required String? token,      // 사용자 인증 토큰
    required String sentence,   // 변환할 문장
    required String savePath,   // 오디오 파일 저장 경로
  }) async {
    try {
      // HTTP 요청 헤더 설정
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // 요청 본문 설정
      final Map<String, String> body = {
        'sentence': sentence,
      };

      // 서버로 POST 요청 전송
      final response = await http.post(
        Uri.parse(apiURL),
        headers: headers,
        body: json.encode(body),
      );

      // 서버 응답 확인
      if (response.statusCode == 200) {
        // 오디오 파일을 바이너리 데이터로 저장
        final audioFile = File(savePath);
        await audioFile.writeAsBytes(response.bodyBytes);
        print('Audio file saved at: $savePath');
        return audioFile;
      } else {
        print('Failed to convert voice. Status code: ${response.statusCode}');
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error occurred while converting text to voice: $e');
      return null;
    }
  }
}
