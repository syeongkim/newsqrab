import 'package:flutter/material.dart';

class HotScrapSection extends StatelessWidget {
  final List<Map<String, dynamic>> scrapData = const [
    {
      'title': '사이언비티 한국 남자 영국 대체, 현장한 기란 자이 국내 4강 진출',
      'profileName': '크랩이',
      'scrapContent': '"시원하네" 한국 남자 양궁 단체, 현격한 기량 차이 꺾고 4강 진출. 일본은 대한민국의 상대가 되지 못했다. 큰 위기조차 없이 경기가 끝났다.',
      'scrapTime': '2024.7.29 10:00 PM',
      'link': 'https://www.fnnews.com/news/202407292153475630',
      'profileImage': 'assets/images/crabi.png',
      'emojis': {'smilecrying': 0, 'crying': 5, 'smile': 0, 'angry': 1}
    },
    {
      'title': '빈항목2',
      'profileName': '크랩이3678abc',
      'scrapContent': '"시원하네" 한국 남자 양궁 단체, 현격한 기량 차이 꺾고 4강 진출. 일본은 대한민국의 상대가 되지 못했다. 큰 위기조차 없이 경기가 끝났다.',
      'scrapTime': '2024.7.29 10:00 PM',
      'link': 'https://www.fnnews.com/news/202407292153475630',
      'profileImage': 'assets/images/crabi.png',
      'emojis': {'smilecrying': 0, 'crying': 5, 'smile': 0, 'angry': 1}
    }
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
    return ListTile(
      title: Text(item['title']),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item['scrapContent']),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.thumb_up, size: 16),
              SizedBox(width: 4),
              Text('${item['emojis']['smilecrying']}'),
              SizedBox(width: 4),
              Icon(Icons.thumb_down, size: 16),
              SizedBox(width: 4),
              Text('${item['emojis']['crying']}'),
              SizedBox(width: 4),
              Icon(Icons.thumb_down, size: 16),
              SizedBox(width: 4),
              Text('${item['emojis']['smile']}'),
              SizedBox(width: 4),
              Icon(Icons.thumb_down, size: 16),
              SizedBox(width: 4),
              Text('${item['emojis']['angry']}'),
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
}
