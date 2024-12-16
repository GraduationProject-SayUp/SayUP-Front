import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sayup/service/chat_service.dart';
import 'package:sayup/service/conversion_service.dart';
import 'package:sayup/service/player_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:path_provider/path_provider.dart';

import 'SignIn.dart';

void main() {
  runApp(const Chatting());
}

class Chatting extends StatelessWidget {
  const Chatting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF262626),
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
  final ConversionService _conversionService = ConversionService();
  final PlayerService _playerService = PlayerService();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastRecognizedWords = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _playerService.initializePlayer(); // 재생기 초기화
  }

  @override
  void dispose() {
    _playerService.dispose();
    super.dispose();
  }

  // 음성 인식 시작
  void _startListening() async {
    if (!_isListening && await _speech.initialize()) {
      setState(() => _isListening = true);

      _speech.listen(
        localeId: 'ko_KR',
        onResult: (result) {
          setState(() {
            _lastRecognizedWords = result.recognizedWords;
            _controller.text = _lastRecognizedWords;
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

  // 메시지 전송 및 조건 처리
  void _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({'sender': 'user', 'message': userMessage});
    });

    _controller.clear();

    // 조건: "ㅇㅇㅇ 발음 알려줘" 패턴 감지
    if (userMessage.contains('발음 알려줘')) {
      final word = userMessage.split(' ')[0]; // "ㅇㅇㅇ" 추출
      await _handlePronunciationRequest(word);
    } else {
      try {
        final botResponse = await _chatService.sendMessageToApi(userMessage);
        setState(() {
          messages.add({'sender': 'bot', 'message': botResponse});
        });
      } catch (e) {
        setState(() {
          messages.add({
            'sender': 'bot',
            'message': 'Error occurred while fetching the response!'
          });
        });
      }
    }

    // 프레임 렌더링 후 스크롤 이동
    _scrollToBottom();
  }

  // 발음 요청 처리
  Future<void> _handlePronunciationRequest(String word) async {
    final String? token = await storage.read(key: 'authToken');

    try {
      final directory = await getApplicationDocumentsDirectory();
      final soundDirectory = Directory('${directory.path}/sound');

      // 폴더가 없으면 생성
      if (!await soundDirectory.exists()) {
        await soundDirectory.create(recursive: true);
      }

      String savePath = '${directory.path}/$word.wav';

      File? audioFile = await _conversionService.convertTextToVoice(
          token: token, sentence: word, savePath: savePath);

      if (audioFile != null) {
        setState(() {
          messages.add({
            'sender': 'bot',
            'message': '$word에 대한 발음입니다.',
            'audioPath': audioFile.path,
          });
        });
      } else {
        setState(() {
          messages.add({'sender': 'bot', 'message': '발음 변환에 실패했습니다.'});
        });
      }
    } catch (e) {
      setState(() {
        messages.add({'sender': 'bot', 'message': '오류가 발생했습니다.'});
      });
    }

    // 프레임 렌더링 후 스크롤 이동
    _scrollToBottom();
  }

  // 스크롤 자동 이동
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 메시지 UI
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
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message['sender'] == 'user';

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Align(
                    alignment:
                    isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: isUserMessage
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: isUserMessage
                                ? const Color(0xFF4C8BF5)
                                : const Color(0xFF424242),
                            borderRadius: BorderRadius.circular(15),
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
                        if (message['audioPath'] != null)
                          IconButton(
                            icon: const Icon(Icons.play_arrow, color: Colors.white70),
                            onPressed: () async {
                              await _playerService.play(message['audioPath'], () {
                                print('Playback finished.');
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildMessageInputArea(),
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