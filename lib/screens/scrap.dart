import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Scrap extends StatefulWidget {
  const Scrap({Key? key}) : super(key: key);

  @override
  _ScrapState createState() => _ScrapState();
}

class _ScrapState extends State<Scrap> {
  List<dynamic> _articles = [];

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    final response = await http.get(Uri.parse('http://localhost:3000/articles')); // 실제 백엔드 API URL로 변경하세요
    if (response.statusCode == 200) {
      setState(() {
        _articles = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load articles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrap News'),
      ),
      body: _articles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_articles[index]['title']),
            subtitle: Text(_articles[index]['author']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleDetailPage(article: _articles[index]),
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
  final dynamic article;

  ArticleDetailPage({required this.article});

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  String? _selectedText;

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
            value: 'very_satisfied',
            child: Row(
              children: [
                Icon(Icons.sentiment_very_satisfied),
                SizedBox(width: 8),
                Text('Very Satisfied'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'satisfied',
            child: Row(
              children: [
                Icon(Icons.sentiment_satisfied),
                SizedBox(width: 8),
                Text('Satisfied'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'neutral',
            child: Row(
              children: [
                Icon(Icons.sentiment_neutral),
                SizedBox(width: 8),
                Text('Neutral'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'dissatisfied',
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
          // 스크랩 기능을 수행합니다.
          // 여기에서 선택된 텍스트와 반응을 저장하는 로직을 추가할 수 있습니다.
          setState(() {
            // 예시: 선택된 텍스트와 반응을 콘솔에 출력
            print('Text: $_selectedText, Reaction: $value');
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            _showPopupMenu(context, details.globalPosition);
          },
          child: SelectableText(
            widget.article['content'],
            showCursor: true,
            onSelectionChanged: (selection, cause) {
              setState(() {
                if (selection.start != -1 && selection.end != -1) {
                  _selectedText = widget.article['content']
                      .substring(selection.start, selection.end)
                      .trim();
                }
              });
            },
          ),
        ),
      ),
    );
  }
}




/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

// Scrap 클래스는 StatefulWidget으로, 스크랩 기능을 제공하는 화면을 구현합니다.
class Scrap extends StatefulWidget {
  const Scrap({Key? key}) : super(key: key);

  @override
  _ScrapState createState() => _ScrapState();
}

class _ScrapState extends State<Scrap> {
  // 사용자가 스크랩한 내용을 저장하는 리스트입니다.
  final List<Map<String, dynamic>> _scrapedContent = [];
  // 사용자가 선택한 텍스트를 저장하는 변수입니다.
  String? _selectedText;
  // 뉴스 기사의 내용을 저장하는 변수입니다.
  String _newsContent = '';
  // 더미 데이터로 사용할 기사 제목입니다.
  String _title = '';

  @override
  void initState() {
    super.initState();
    _loadNewsContent();
  }

  // JSON 파일에서 데이터 불러오기
  Future<void> _loadNewsContent() async {
    String jsonString = await rootBundle.loadString('assets/news/dummy_news.json');
    final Map<String, dynamic> newsData = jsonDecode(jsonString);

    setState(() {
      _title = newsData['title'];
      _newsContent = newsData['content'];
    });
  }

  // 사용자가 텍스트를 선택했을 때 팝업 메뉴를 표시하는 메서드입니다.
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
            value: 'very_satisfied',
            child: Row(
              children: [
                Icon(Icons.sentiment_very_satisfied),
                SizedBox(width: 8),
                Text('Very Satisfied'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'satisfied',
            child: Row(
              children: [
                Icon(Icons.sentiment_satisfied),
                SizedBox(width: 8),
                Text('Satisfied'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'neutral',
            child: Row(
              children: [
                Icon(Icons.sentiment_neutral),
                SizedBox(width: 8),
                Text('Neutral'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'dissatisfied',
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
            _scrapedContent.add({
              'text': _selectedText!,
              'reaction': value,
            });
            _selectedText = null;
          });
        }
      });
    }
  }

  // 이모티콘 반응에 따른 아이콘을 반환하는 메서드입니다.
  Icon _getReactionIcon(String reaction) {
    switch (reaction) {
      case 'very_satisfied':
        return Icon(Icons.sentiment_very_satisfied);
      case 'satisfied':
        return Icon(Icons.sentiment_satisfied);
      case 'neutral':
        return Icon(Icons.sentiment_neutral);
      case 'dissatisfied':
        return Icon(Icons.sentiment_dissatisfied);
      default:
        return Icon(Icons.sentiment_neutral);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrap News'),
      ),
      body: _newsContent.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _showPopupMenu(context, details.globalPosition);
                },
                child: SelectableText(
                  _newsContent,
                  showCursor: true,
                  onSelectionChanged: (selection, cause) {
                    setState(() {
                      if (selection.start != -1 && selection.end != -1) {
                        _selectedText = _newsContent.substring(selection.start, selection.end).trim();
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _scrapedContent.isNotEmpty ? _showScrapResult : null,
            child: Text('스크랩 하기'),
          ),
        ],
      ),
    );
  }

  // 스크랩 결과를 보여주는 메서드입니다.
  void _showScrapResult() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      ..._scrapedContent.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(child: Text('• ${item['text']}')),
                              _getReactionIcon(item['reaction']),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}
*/