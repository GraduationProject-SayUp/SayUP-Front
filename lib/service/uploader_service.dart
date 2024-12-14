import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 파일 업로드 관련 기능을 제공하는 서비스
class UploaderService {
  // 토큰 읽기
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // 파일 업로드
  Future<void> uploadFile(String filePath) async {
    // 저장된 JWT 토큰 가져오기
    final String? token = await storage.read(key: 'authToken');
    if (token == null) {
      throw Exception('Authorization token is missing');
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8000/upload'), // 안드로이드 에뮬레이터용 localhost 주소
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        filePath,
        filename: 'recorded_audio.wav',
      ),
    );

    // Authorization 헤더에 Bearer 토큰 추가
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Upload successful');
    } else {
      throw Exception('Upload failed with status code: ${response.statusCode}');
    }
  }
}
