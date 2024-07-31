import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../services/user_provider.dart';
import '../../services/reels_service.dart';

class ArticleDetailPage extends StatefulWidget {
  final String articleId;

  ArticleDetailPage({required this.articleId});

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  Future<dynamic>? _articleFuture;
  String? _selectedText; // 선택된 텍스트를 저장할 변수
  String? _selectedEmoji; // 선택된 이모지를 저장할 변수
  bool _isScrapButtonVisible = false; // 스크랩 버튼의 가시성을 제어할 변수

  @override
  void initState() {
    super.initState();
    _articleFuture = ReelsService().fetchArticleById(widget.articleId);
  }

  // 팝업 메뉴를 표시하는 메서드
  void _showPopupMenu(BuildContext context, Offset position) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    if (_selectedText != null && _selectedText!.isNotEmpty) {
      showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromPoints(position, position),
          Offset.zero & overlay.size,
        ),
        items: [
          PopupMenuItem(
            value: 'sentiment_very_satisfied',
            child: Row(
              children: [
                Icon(Icons.sentiment_very_satisfied),
                SizedBox(width: 8),
                Text('Very Satisfied'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'sentiment_satisfied',
            child: Row(
              children: [
                Icon(Icons.sentiment_satisfied),
                SizedBox(width: 8),
                Text('Satisfied'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'sentiment_neutral',
            child: Row(
              children: [
                Icon(Icons.sentiment_neutral),
                SizedBox(width: 8),
                Text('Neutral'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'sentiment_dissatisfied',
            child: Row(
              children: [
                Icon(Icons.sentiment_dissatisfied),
                SizedBox(width: 8),
                Text('Dissatisfied'),
              ],
            ),
          ),
        ],
      ).then((value) {
        if (value != null) {
          setState(() {
            _selectedEmoji = value; // 선택된 이모지를 저장
            _isScrapButtonVisible = true; // 스크랩 버튼 가시화
          });
        }
      });
    }
  }

  // 스크랩 데이터를 서버에 전송하는 메서드
  Future<void> _scrapArticle() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final article = await _articleFuture; // Fetch article details

    final scrapData = {
      "title": article['title'], // 기사 제목
      "url": article['url'], // 기사 URL
      "date": article['date'], // 기사 날짜
      "userId": userProvider.userId, // 실제 사용자 ID로 변경됨
      "usernickname": userProvider.nickname, // 사용자 닉네임 추가
      "articleId": article['_id'], // 기사 ID
      "highlightedText": _selectedText, // 선택된 텍스트
      "myemoji": _selectedEmoji, // 선택된 이모지
      "followerEmojis": [], // 팔로워 이모지 초기화
      "createdAt": DateTime.now().toIso8601String(), // 생성 시간
      "updatedAt": DateTime.now().toIso8601String(), // 업데이트 시간
    };

    try {
      final response = await http.post(
        Uri.parse('http://175.106.98.197:3000/scraps'), // 백엔드 API URL로 변경
        headers: {"Content-Type": "application/json"}, // 요청 헤더 설정
        body: jsonEncode(scrapData), // 스크랩 데이터를 JSON으로 인코딩
      );

      if (response.statusCode == 201) {
        // 요청이 성공적일 때
        Navigator.pop(context); // 리스트 페이지로 돌아감
      } else {
        print(
            'Failed to scrap article with status code: ${response.statusCode}'); // 오류 상태 코드 출력
        throw Exception('Failed to scrap article'); // 예외 발생
      }
    } catch (e) {
      print('Error scrapping article: $e'); // 예외 발생 시 오류 메시지 출력
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _articleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading...'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (snapshot.hasData) {
          var article = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(article['title'] ?? 'Article Detail'),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['title'] ?? 'No Title',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text(article['author'] ?? 'No Author'),
                      SizedBox(height: 16.0),
                      GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          _showPopupMenu(context, details.globalPosition); // 팝업 메뉴 표시
                        },
                        child: SelectableText(
                          article['content'] ?? 'No Content',
                          showCursor: true,
                          onSelectionChanged: (selection, cause) {
                            setState(() {
                              if (selection.start != -1 && selection.end != -1) {
                                _selectedText = article['content']
                                    .substring(selection.start, selection.end)
                                    .trim(); // 선택된 텍스트 저장
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isScrapButtonVisible)
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: ElevatedButton(
                      onPressed: _scrapArticle, // 스크랩 버튼 클릭 시 서버에 데이터 전송
                      child: Text('스크랩 하기'),
                    ),
                  ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('No Data'),
            ),
            body: Center(
              child: Text('No Data Available'),
            ),
          );
        }
      },
    );
  }
}
