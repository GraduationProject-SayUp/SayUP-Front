import 'package:flutter/material.dart';
import 'package:sayup/service/chat_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; // 음성 인식 패키지 추가

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
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, String>> messages = [];
  late stt.SpeechToText _speech; // 음성 인식 객체
  bool _isListening = false; // 현재 듣고 있는지 여부
  String _lastRecognizedWords = ""; // 마지막으로 인식한 텍스트

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText(); // 음성 인식 초기화
  }

  // 음성 인식 시작
  void _startListening() async {
    if (!_isListening && await _speech.initialize()) {
      setState(() => _isListening = true);

      _speech.listen(
        localeId: 'ko_KR', // 한국어로 언어 설정
        onResult: (result) {
          setState(() {
            _lastRecognizedWords = result.recognizedWords; // 음성을 텍스트로 변환
            _controller.text = _lastRecognizedWords; // 입력 필드에 채우기
          });
        },
      );
    }
  }

  // 음성 인식 중지
  void _stopListening() {
    if (_isListening) {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  // 메시지 전송
  void _sendMessage() async {
    final userMessage = _controller.text;
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({'sender': 'user', 'message': userMessage});
    });

    _controller.clear();

    try {
      final botResponse = await _chatService.sendMessage(userMessage);
      setState(() {
        messages.add({'sender': 'bot', 'message': botResponse});
      });
    } catch (e) {
      setState(() {
        messages.add({'sender': 'bot', 'message': 'Error occurred while fetching the response!'});
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  // 자동 스크롤
  void _scrollToBottom() {
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
      backgroundColor: Color(0xFF262626),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Free Talking',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 메시지 리스트
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
                    alignment:
                    isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: isUserMessage
                            ? Color(0xFF4C8BF5)
                            : Color(0xFF424242),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        message['message']!,
                        style: TextStyle(
                          color: isUserMessage
                              ? Colors.white
                              : Colors.white70,
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

  // 입력 영역
  Widget _buildMessageInputArea() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Color(0xFF1F1F1F),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF333333),
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
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            // 녹음 버튼
            CircleAvatar(
              backgroundColor: Color(0xFF3A6FF7),
              radius: 25,
              child: IconButton(
                icon: Icon(
                  _isListening ? Icons.mic : Icons.mic_none, // 상태에 따라 아이콘 변경
                  color: Colors.white,
                ),
                onPressed: _isListening ? _stopListening : _startListening,
              ),
            ),
            SizedBox(width: 10),
            // 보내기 버튼
            CircleAvatar(
              backgroundColor: Color(0xFF3A6FF7),
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


/*
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
  final ChatService _chatService = ChatService(); // 백엔드 주소 설정
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> messages = [];

  // 메시지 보내기
  void _sendMessage() async {
    final userMessage = _controller.text;
    if (userMessage.isEmpty) return;

    // 사용자의 메시지를 화면에 추가
    setState(() {
      messages.add({'sender': 'user', 'message': userMessage});
    });

    _controller.clear();

    // 백엔드 호출 및 응답 처리
    try {
      final botResponse = await _chatService.sendMessage(userMessage);

      setState(() {
        messages.add({'sender': 'bot', 'message': botResponse});
      });
    } catch (e) {
      setState(() {
        messages.add({'sender': 'bot', 'message': 'Error occurred while fetching the response!'});
      });
    }

    // 스크롤을 자동으로 아래로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  // 자동 스크롤
  void _scrollToBottom() {
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
      backgroundColor: Color(0xFF262626),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Free Talking',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 메시지 리스트
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
                    alignment:
                    isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: isUserMessage
                            ? Color(0xFF4C8BF5)
                            : Color(0xFF424242),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        message['message']!,
                        style: TextStyle(
                          color: isUserMessage
                              ? Colors.white
                              : Colors.white70,
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

  // 입력 영역
  Widget _buildMessageInputArea() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Color(0xFF1F1F1F),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF333333),
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
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Color(0xFF3A6FF7),
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
*/