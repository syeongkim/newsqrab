import 'package:flutter/material.dart'; // Flutter의 기본 위젯 패키지 임포트
import 'package:http/http.dart' as http; // HTTP 요청을 위한 패키지 임포트
import 'dart:convert'; // JSON 변환을 위한 패키지 임포트

class Scrap extends StatefulWidget {
  const Scrap({Key? key}) : super(key: key);

  @override
  _ScrapState createState() => _ScrapState();
}

class _ScrapState extends State<Scrap> {
  List<dynamic> _articles = []; // 기사를 저장할 리스트 변수

  @override
  void initState() {
    super.initState();
    _fetchArticles(); // 위젯 초기화 시 기사를 불러오는 메서드 호출
  }

  Future<void> _fetchArticles() async {
    // API로부터 기사를 가져오는 비동기 메서드
    final response = await http.get(Uri.parse('http://10.40.0.130:3000/articles')); // 백엔드 API 호출
    if (response.statusCode == 200) {
      // 요청이 성공적일 때
      setState(() {
        _articles = jsonDecode(response.body); // JSON 응답을 디코딩하여 _articles에 저장
      });
    } else {
      throw Exception('Failed to load articles'); // 요청 실패 시 예외 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar의 title을 제거
        title: null,
        // AppBar를 빈 공간으로 대체 (필요에 따라 preferredSize를 사용)
        toolbarHeight: 0, // AppBar의 높이를 0으로 설정
        elevation: 0, // 그림자 효과를 제거
      ),
      body: _articles.isEmpty
          ? Center(child: CircularProgressIndicator()) // 기사가 없을 때 로딩 표시
          : ListView.builder(
        // 기사가 있을 때 리스트로 보여줌
        itemCount: _articles.length, // 기사 개수
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_articles[index]['title']), // 기사 제목 표시
            subtitle: Text(_articles[index]['author']), // 기사 저자 표시
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailPage(article: _articles[index]), // 기사 클릭 시 상세 페이지로 이동
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ArticleDetailPage extends StatefulWidget {
  final dynamic article; // 기사를 저장할 변수

  ArticleDetailPage({required this.article});

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  String? _selectedText; // 선택된 텍스트를 저장할 변수
  String? _selectedEmoji; // 선택된 이모지를 저장할 변수
  bool _isScrapButtonVisible = false; // 스크랩 버튼의 가시성을 제어할 변수

  void _showPopupMenu(BuildContext context, Offset position) {
    // 팝업 메뉴를 표시하는 메서드
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

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

  Future<void> _scrapArticle() async {
    // 스크랩 데이터를 서버에 전송하는 메서드
    final scrapData = {
      "title": widget.article['title'], // 기사 제목
      "url": widget.article['url'], // 기사 URL
      "date": widget.article['date'], // 기사 날짜
      "userId": "60d0fe4f5311236168a109ca",  // 실제 사용자 ID로 변경해야 함
      "articleId": widget.article['_id'], // 기사 ID
      "highlightedText": _selectedText, // 선택된 텍스트
      "myemoji": _selectedEmoji, // 선택된 이모지
      "followerEmojis": [], // 팔로워 이모지 초기화
      "createdAt": DateTime.now().toIso8601String(), // 생성 시간
      "updatedAt": DateTime.now().toIso8601String(), // 업데이트 시간
    };

    final response = await http.post(
      Uri.parse('http://10.40.0.130:3000/scraps'), // 백엔드 API URL로 변경
      headers: {"Content-Type": "application/json"}, // 요청 헤더 설정
      body: jsonEncode(scrapData), // 스크랩 데이터를 JSON으로 인코딩
    );

    if (response.statusCode == 201) {
      // 요청이 성공적일 때
      Navigator.pop(context); // 리스트 페이지로 돌아감
    } else {
      throw Exception('Failed to scrap article'); // 요청 실패 시 예외 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article['title']), // 기사 제목 표시
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    _showPopupMenu(context, details.globalPosition); // 팝업 메뉴 표시
                  },
                  child: SelectableText(
                    widget.article['content'], // 기사 내용 표시
                    showCursor: true,
                    onSelectionChanged: (selection, cause) {
                      setState(() {
                        if (selection.start != -1 && selection.end != -1) {
                          _selectedText = widget.article['content']
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _scrapArticle, // 스크랩 버튼 클릭 시 서버에 데이터 전송
                child: Text('스크랩 하기'),
              ),
            ),
        ],
      ),
    );
  }
}

