import 'package:flutter/material.dart';

class HotScrapSection extends StatelessWidget {
  final List<Map<String, dynamic>> scrapData = [
    {
      'title': '사이언비티' '한국 남자 영국 대체, 현장한 기란 자이 국내 4강 진출',
      'description':
          '올림픽 대한민국의 선다가 되지 못했다. 득 의 기조상 많이 경기가 특보다.',
      'emojis': {'smilecrying': 0, 'crying': 5, 'smile': 0, 'angry': 1},
    },
    {
      'title': '빈항목2',
      'description': '여기에 뉴스 설명을 넣어주세요.',
      'emojis': {'smilecrying': 0, 'crying': 5, 'smile': 0, 'angry': 1},
    },
    // 나머지 항목들도 이와 비슷하게 추가
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          // leading: CircleAvatar(
          //   radius: 12.5, // 원하는 원형 크기 (이미지 크기의 절반)
          //   backgroundImage: AssetImage('assets/images/newsQrab.jpg'),
          // ),
          title: Text(
            'Hottest Scraps',
            style: TextStyle(
              fontSize: 20.0, // 원하는 글자 크기
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
          Text(item['description']),
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
              Icon(Icons.thumb_down, size: 16),
              SizedBox(width: 4),
              Text('${item['emojis']['smile']}'),
              Icon(Icons.thumb_down, size: 16),
              SizedBox(width: 4),
              Text('${item['emojis']['angry']}'),
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
}
