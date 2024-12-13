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
      // AppBar 추가하여 뒤로가기 버튼 구현
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white70), // 뒤로가기 아이콘
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Chatting', style: TextStyle
          (color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          // 더보기 옵션 아이콘
          IconButton(icon: Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () {
              // 추가 옵션 메뉴 구현 가능
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // 메시지 리스트 영역
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message['sender'] == 'user';

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Align(
                    // 메시지 정렬 (사용자/봇에 따라 다름)
                    alignment: isUserMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      // 메시지 최대 너비 제한
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10
                      ),
                      // 메시지 컨테이너 디자인
                      decoration: BoxDecoration(
                          color: isUserMessage
                              ? Color(0xFF4A90E2)  // 사용자 메시지 블루
                              : Color(0xFF2C2C2C), // 봇 메시지 그레이
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: Offset(0, 2)
                            )
                          ]
                      ),
                      child: Text(
                        message['message']!,
                        style: TextStyle(
                          color: isUserMessage ? Colors.white : Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // 메시지 입력 영역
          _buildMessageInputArea()
        ],
      ),
    );
  }

  // 메시지 입력 위젯 빌더
  Widget _buildMessageInputArea() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Color(0xFF2A2A2A),
      child: SafeArea(
        child: Row(
          children: [
            // 메시지 입력 텍스트 필드
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _controller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            // 메시지 전송 버튼
            CircleAvatar(
              backgroundColor: Color(0xFF4A90E2),
              radius: 25,
              child: IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: _sendMessage,
              ),
            )
          ],
        ),
      ),
    );
  }
}