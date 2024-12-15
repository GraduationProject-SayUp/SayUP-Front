import 'package:http/http.dart' as http;

class ChatService {
  final String _baseUrl = "http://127.0.0.1:8080/api/chat/generate"; // Spring Boot 백엔드 주소 (ios 시뮬레이터의 경우 127.0.0.1:8080) / 안드로이드 애뮬레이터의 경우 10.0.2.2:8080

  Future<String> sendMessage(String userMessage) async {
    try {
      // HTTP POST 요청 생성
      final response = await http.post(
        Uri.parse("$_baseUrl?message=$userMessage"), // 쿼리 파라미터로 메시지 전달
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        // 응답이 성공적일 경우
        return response.body; // 백엔드에서 content 값만 반환
      } else {
        throw Exception("Failed to load response: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      return "Error occurred while fetching response.";
    }
  }
}
