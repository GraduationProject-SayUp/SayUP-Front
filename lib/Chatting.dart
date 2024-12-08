import 'package:flutter/material.dart';
import 'package:sayup/service/chat_service.dart';

void main() {
  runApp(const Chatting());
}

class Chatting extends StatelessWidget {
  const Chatting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF262626),
      ),
      home: ChattingPage(),
    );
  }
}

class ChattingPage extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChattingPage> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService(apiURL: 'localhost');
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러 추가
  List<Map<String, String>> messages = [];

  // 메시지 보내기
  void _sendMessage() async {
    final userMessage = _controller.text;
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({
        'sender': 'user',
        'message': userMessage,
      });
    });

    _controller.clear();

    // 백엔드 서버에 메시지 보내기
    String botResponse = await _chatService.sendMessageToApi(userMessage);

    setState(() {
      messages.add({
        'sender': 'bot',
        'message': botResponse,
      });
    });

    // 메시지 보내고 난 후, 스크롤을 자동으로 맨 아래로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  // 자동으로 스크롤을 맨 아래로 이동
  void _scrollToBottom() {
    // 스크롤이 끝에 있을 때만 애니메이션을 추가
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 좌측 상단에 로고 이미지 배치
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 40),
            child: Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/images/logo_grayscale_big.png', // 로고 이미지 경로
                height: 80,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // 스크롤 컨트롤러 연결
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message['sender'] == 'user';

                return ListTile(
                  title: Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.blueAccent : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        message['message']!,
                        style: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0), // 입력 박스 높이 조정
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
