import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../services/user_provider.dart';

// Scrap 위젯 클래스
class Scrap extends StatefulWidget {
  const Scrap({Key? key}) : super(key: key);

  @override
  _ScrapState createState() => _ScrapState();
}

// Scrap 위젯의 상태 클래스
class _ScrapState extends State<Scrap> {
  List<dynamic> _articles = []; // 기사를 저장할 리스트 변수
  String? _selectedCategory; // 선택된 카테고리를 저장할 변수

  @override
  void initState() {
    super.initState();
    _fetchArticles(); // 위젯 초기화 시 모든 기사를 불러오는 메서드 호출
  }

  // 카테고리에 따라 기사를 가져오는 비동기 메서드
  Future<void> _fetchArticles([String? category]) async {
    final url = category == null
        ? 'http://175.106.98.197:3000/articles' // 카테고리가 없을 때 모든 기사를 가져옴
        : 'http://175.106.98.197:3000/articles/$category'; // 선택된 카테고리의 기사만 가져옴
    try {
      final response = await http.get(Uri.parse(url)); // 백엔드 API 호출
      if (response.statusCode == 200) {
        // 요청이 성공적일 때
        setState(() {
          _articles = jsonDecode(response.body); // JSON 응답을 디코딩하여 _articles에 저장
        });
      } else {
        print('Failed to load articles with status code: ${response.statusCode}'); // 오류 상태 코드 출력
        throw Exception('Failed to load articles'); // 예외 발생
      }
    } catch (e) {
      print('Error fetching articles: $e'); // 예외 발생 시 오류 메시지 출력
    }
  }

  // 카테고리 선택 시 호출되는 메서드
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category; // 선택된 카테고리 설정
    });
    _fetchArticles(category); // 선택된 카테고리의 기사 불러오기
  }

  // 카테고리 버튼을 생성하는 메서드
  Widget _buildCategoryButton(String label) {
    return GestureDetector(
      onTap: () => _onCategorySelected(label), // 버튼 클릭 시 카테고리 선택
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0), // 버튼의 좌우 여백 설정
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0), // 버튼 내 텍스트와 테두리 사이의 여백
        decoration: BoxDecoration(
          color: Colors.grey, // 버튼 배경색을 회색으로 설정
          borderRadius: BorderRadius.circular(10.0), // 버튼의 모서리 둥글게
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // 그림자 색상
              offset: Offset(0, 4), // 그림자의 위치
              blurRadius: 6.0, // 그림자 흐림 정도
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white, // 텍스트 색상
              fontSize: 16.0, // 텍스트 크기
              fontWeight: FontWeight.bold, // 텍스트 두께
            ),
          ),
        ),
      ),
    );
  }

  // 위젯을 빌드하는 메서드
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null, // AppBar의 title을 제거
        toolbarHeight: 0, // AppBar의 높이를 0으로 설정
        elevation: 0, // 그림자 효과를 제거
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0), // 상단 패딩 추가
          Container(
            height: 80.0, // 버튼 컨테이너의 높이 설정
            child: ListView(
              scrollDirection: Axis.horizontal, // 수평 스크롤 설정
              children: [
                _buildCategoryButton('연예'),
                _buildCategoryButton('사회'),
                _buildCategoryButton('스포츠'),
                _buildCategoryButton('경영경제'),
                _buildCategoryButton('정치'),
                _buildCategoryButton('문화'),
                _buildCategoryButton('과학기술'),
                _buildCategoryButton('세계'),
              ],
            ),
          ),
          SizedBox(height: 16.0), // 하단 패딩 추가
          Expanded(
            child: _articles.isEmpty
                ? Center(child: CircularProgressIndicator()) // 기사가 없을 때 로딩 표시
                : ListView.builder(
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
          ),
        ],
      ),
    );
  }
}

// 기사 상세 페이지 클래스
class ArticleDetailPage extends StatefulWidget {
  final dynamic article; // 기사를 저장할 변수

  ArticleDetailPage({required this.article});

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

// 기사 상세 페이지의 상태 클래스
class _ArticleDetailPageState extends State<ArticleDetailPage> {
  String? _selectedText; // 선택된 텍스트를 저장할 변수
  String? _selectedEmoji; // 선택된 이모지를 저장할 변수
  bool _isScrapButtonVisible = false; // 스크랩 버튼의 가시성을 제어할 변수

  // 팝업 메뉴를 표시하는 메서드
  void _showPopupMenu(BuildContext context, Offset position) {
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

  // 스크랩 데이터를 서버에 전송하는 메서드
  Future<void> _scrapArticle() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final scrapData = {
      "title": widget.article['title'], // 기사 제목
      "url": widget.article['url'], // 기사 URL
      "date": widget.article['date'], // 기사 날짜
      "userId": userProvider.userId, // 실제 사용자 ID로 변경됨
      "usernickname": userProvider.nickname, // 사용자 닉네임 추가
      "articleId": widget.article['_id'], // 기사 ID
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
        print('Failed to scrap article with status code: ${response.statusCode}'); // 오류 상태 코드 출력
        throw Exception('Failed to scrap article'); // 예외 발생
      }
    } catch (e) {
      print('Error scrapping article: $e'); // 예외 발생 시 오류 메시지 출력
    }
  }

  // 위젯을 빌드하는 메서드
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
