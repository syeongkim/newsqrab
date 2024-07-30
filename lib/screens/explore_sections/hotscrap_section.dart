import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HotScrapSection extends StatelessWidget {
  final List<Map<String, dynamic>> scrapData = [
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
          )
        ],
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('${item['title']}의 상세 정보'),
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
