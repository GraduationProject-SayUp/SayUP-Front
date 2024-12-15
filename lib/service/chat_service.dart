import 'dart:convert';

import 'package:http/http.dart' as http;

// 유저가 입력한 메시지를 백엔드 서버에 전송 하는 서비스
class ChatService {
  final String apiURL = 'http://127.0.0.1:8080/api/chat/generate';  // API endpoint URL (ios 애뮬레이터 -> 127.0.0.1 안드로이드 애뮬레이터 -> 10.0.0.2)

  // OpenAI API로 유저가 입력한 채팅 메시지 전달
  Future<String> sendMessageToApi(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse('$apiURL?message=${Uri.encodeComponent(userMessage)}'), // 쿼리 파라미터로 message 추가
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message': userMessage,
        }),
      );

      if (response.statusCode == 200) {
        try {
          // JSON 형식일 경우만 파싱
          final responseData = json.decode(response.body);
          return responseData['response'];
        } catch (e) {
          // JSON이 아니면 그냥 문자열 그대로 반환
          return response.body;
        }
      } else { // 응답 실패 시 반환 되는 값
        return 'Failed to get a response from the server.';
      }
    } catch (e) {
      return 'Error occurred: $e';
    }
  }
}