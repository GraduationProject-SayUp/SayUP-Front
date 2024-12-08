import 'dart:convert';

import 'package:http/http.dart' as http;

// 유저가 입력한 메시지를 백엔드 서버에 전송 하는 서비스
class ChatService {
  final String apiURL;

  ChatService ({required this.apiURL});

  // OpenAI API로 유저가 입력한 채팅 메시지 전달
  Future<String> sendMessageToApi(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(apiURL),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message': userMessage,
        }),
      );

      if (response.statusCode == 200) {
        // 응답 성공 시 JSON 파싱
        final responseData = json.decode(response.body);
        return responseData['response']; // 서버에서 보내준 응답을 반환
      } else { // 응답 실패 시 반환 되는 값
        return 'Failed to get a response from the server.';
      }
    } catch (e) {
      return 'Error occurred: $e';
    }
  }
}