import 'package:flutter/material.dart';
import 'package:newsqrap/services/scrap_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'scrap_service.dart'; // fetchHotScraps 메서드가 포함된 ScrapService 클래스 가져오기

class HotScrapSection extends StatefulWidget {
  @override
  _HotScrapSectionState createState() => _HotScrapSectionState();
}

class _HotScrapSectionState extends State<HotScrapSection> {
  late Future<List<Map<String, dynamic>>> _hotScrapsFuture;

  @override
  void initState() {
    super.initState();
    _hotScrapsFuture = fetchHotScraps();
  }

  Future<List<Map<String, dynamic>>> fetchHotScraps() async {
    final scrapService = ScrapService();
    final scraps = await scrapService.fetchHotScraps();
    return scraps.cast<Map<String, dynamic>>(); // 타입 캐스팅
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            'Hottest Scraps',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        Container(
          height: 300,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _hotScrapsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Failed to load hot scraps'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No hot scraps available'));
              } else {
                final scrapData = snapshot.data!;
                return ListView.builder(
                  itemCount: scrapData.length,
                  itemBuilder: (context, index) {
                    return _buildHotScrapItem(context, scrapData[index]);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHotScrapItem(BuildContext context, Map<String, dynamic> item) {
    IconData _getEmojiIcon(String emoji) {
      switch (emoji) {
        case 'sentiment_very_satisfied':
          return Icons.sentiment_very_satisfied;
        case 'sentiment_satisfied':
          return Icons.sentiment_satisfied;
        case 'sentiment_dissatisfied':
          return Icons.sentiment_dissatisfied;
        case 'sentiment_very_dissatisfied':
          return Icons.sentiment_very_dissatisfied;
        default:
          return Icons.sentiment_neutral;
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // 회색 배경
        borderRadius: BorderRadius.circular(20), // 둥근 모서리
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2), // 그림자의 위치 조정
          ),
        ],
      ),
      child: ListTile(
        title: Text(item['title'] ?? 'No title'), // null 체크
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['description'] ?? 'No description'), // null 체크
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['scrapTime'] ?? 'No time', // null 체크
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Icon(
                  _getEmojiIcon(item['emoji'] ?? 'sentiment_neutral'), // null 체크
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final url = item['link'] ?? '';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch $url')),
                  );
                }
              },
              child: Text(
                '원문보기',
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildReactionIcon(
                  Icons.sentiment_very_satisfied,
                  item['reactions']?['sentiment_very_satisfied'] ?? 0, // null 체크
                ),
                _buildReactionIcon(
                  Icons.sentiment_satisfied,
                  item['reactions']?['sentiment_satisfied'] ?? 0, // null 체크
                ),
                _buildReactionIcon(
                  Icons.sentiment_dissatisfied,
                  item['reactions']?['sentiment_dissatisfied'] ?? 0, // null 체크
                ),
                _buildReactionIcon(
                  Icons.sentiment_very_dissatisfied,
                  item['reactions']?['sentiment_very_dissatisfied'] ?? 0, // null 체크
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          _showPopup(context, item);
        },
      ),
    );
  }

  Widget _buildReactionIcon(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        SizedBox(width: 4),
        Text(count.toString(), style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  void _showPopup(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200], // 팝업 배경 색상 회색
          contentPadding: EdgeInsets.all(0),
          content: Container(
            width: 300,
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: item['profileImage'] != null
                          ? AssetImage(item['profileImage'])
                          : null,
                      child: item['profileImage'] == null
                          ? Icon(Icons.person, size: 20)
                          : null,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item['profileName'] ?? 'No name', // null 체크
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    item['scrapContent'] ?? 'No content', // null 체크
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft, // 시간 왼쪽 정렬
                  child: Text(
                    item['scrapTime'] ?? 'No time', // null 체크
                    style: TextStyle(
                      color: Colors.grey, // 시간 텍스트 색상 회색으로 설정
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.sentiment_very_satisfied),
                      onPressed: () {},
                    ),
                    Text('${item['emojis']?['smilecrying'] ?? 0}'), // null 체크
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.sentiment_satisfied),
                      onPressed: () {},
                    ),
                    Text('${item['emojis']?['crying'] ?? 0}'), // null 체크
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.sentiment_dissatisfied),
                      onPressed: () {},
                    ),
                    Text('${item['emojis']?['smile'] ?? 0}'), // null 체크
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.sentiment_very_dissatisfied),
                      onPressed: () {},
                    ),
                    Text('${item['emojis']?['angry'] ?? 0}'), // null 체크
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
