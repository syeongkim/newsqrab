import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HotScrapSection extends StatelessWidget {
  final List<Map<String, dynamic>> scrapData = const [
    {
      'title': '사이언비티' '한국 남자 영국 대체, 현장한 기란 자이 국내 4강 진출',
      'description':
      '올림픽 대한민국의 선다가 되지 못했다. 득 의 기조상 많이 경기가 특보다.',
      'link': 'https://www.fnnews.com/news/202407292153475630',
      'scrapTime': '2024.7.29 10:00 PM',
      'emoji': 'sentiment_very_dissatisfied',
      'reactions': {
        'sentiment_very_satisfied': 0,
        'sentiment_satisfied': 1,
        'sentiment_dissatisfied': 0,
        'sentiment_very_dissatisfied': 5
      },
    },
    {
      'title': '빈항목2',
      'description': '여기에 뉴스 설명을 넣어주세요.',
      'link': 'https://www.fnnews.com/news/202407292153475630',
      'scrapTime': '2024.7.29 10:00 PM',
      'emoji': 'sentiment_satisfied',
      'reactions': {
        'sentiment_very_satisfied': 0,
        'sentiment_satisfied': 5,
        'sentiment_dissatisfied': 0,
        'sentiment_very_dissatisfied': 1
      },
    },
  ];

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
          height: 150,
          child: ListView.builder(
            itemCount: scrapData.length,
            itemBuilder: (context, index) {
              return _buildHotScrapItem(context, scrapData[index]);
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

    return ListTile(
      title: Text(item['title']),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item['description']),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['scrapTime'],
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Icon(
                _getEmojiIcon(item['emoji']),
                size: 14,
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final url = item['link'];
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
                item['reactions']['sentiment_very_satisfied'],
              ),
              _buildReactionIcon(
                Icons.sentiment_satisfied,
                item['reactions']['sentiment_satisfied'],
              ),
              _buildReactionIcon(
                Icons.sentiment_dissatisfied,
                item['reactions']['sentiment_dissatisfied'],
              ),
              _buildReactionIcon(
                Icons.sentiment_very_dissatisfied,
                item['reactions']['sentiment_very_dissatisfied'],
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        _showPopup(context, item);
      },
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
                      backgroundImage: AssetImage(item['profileImage']),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item['profileName'],
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
                    item['scrapContent'],
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft, // 시간 왼쪽 정렬
                  child: Text(
                    item['scrapTime'],
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
                    Text('${item['emojis']['smilecrying']}'),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.sentiment_satisfied),
                      onPressed: () {},
                    ),
                    Text('${item['emojis']['crying']}'),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.sentiment_dissatisfied),
                      onPressed: () {},
                    ),
                    Text('${item['emojis']['smile']}'),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.sentiment_very_dissatisfied),
                      onPressed: () {},
                    ),
                    Text('${item['emojis']['angry']}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
}
