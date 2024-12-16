import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatService {
  final String apiURL = 'http://10.0.2.2:8080/api/chat/generate';
  final storage = FlutterSecureStorage();

  // 토큰을 포함한 메시지 전송 메서드
  Future<String> sendMessageToApi(String userMessage) async {
    try {
      // 저장된 토큰 불러오기
      final String? token = await storage.read(key: 'authToken');

      if (token == null) {
        return 'Authentication token is missing. Please log in.';
      }

      final response = await http.post(
        Uri.parse(apiURL),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // 토큰 추가
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
          // JSON이 아니면 그대로 문자열 반환
          return response.body;
        }
      } else {
        // 응답 실패 시 상세 오류 메시지 반환
        return 'Failed to get a response: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Network error occurred: $e';
    }
  }
}