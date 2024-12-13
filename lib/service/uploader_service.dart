import 'package:http/http.dart' as http;

/// 파일 업로드 관련 기능을 제공하는 서비스
class UploaderService {
  // 파일 업로드
  Future<void> uploadFile(String filePath) async {
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

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Upload failed');
    }
  }
}
