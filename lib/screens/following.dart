import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Following extends StatefulWidget {
  const Following({Key? key}) : super(key: key);

  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  final List<Map<String, String>> scrapData = const [
    {
      "profileName": "크랩이",
      "scrapContent": "\"시원하네\" 한국 남자 양궁 단체, 현격한 기량 차이 꺾고 4강 진출. 일본은 대한민국의 상대가 되지 못했다. 큰 위기조차 없이 경기가 끝났다.",
      "scrapTime": "2024.7.29 10:00 PM",
      "link": "https://www.fnnews.com/news/202407292153475630",
      "profileImage": "assets/images/crabi.png"
    },
    {
      "profileName": "크랩이3678abc",
      "scrapContent": "\"시원하네\" 한국 남자 양궁 단체, 현격한 기량 차이 꺾고 4강 진출. 일본은 대한민국의 상대가 되지 못했다. 큰 위기조차 없이 경기가 끝났다.",
      "scrapTime": "2024.7.29 10:00 PM",
      "link": "https://www.fnnews.com/news/202407292153475630",
      "profileImage": "assets/images/newsQrab.jpg"
    }
  ];

  // 이모티콘 카운트를 관리하는 리스트
  List<List<int>> emojiCounts = [];

  @override
  void initState() {
    super.initState();
    // 각 스크랩에 대해 이모티콘 카운트 초기화
    emojiCounts = List.generate(scrapData.length, (index) => [0, 0, 0, 0]);
  }

  void _incrementEmoji(int scrapIndex, int emojiIndex) {
    setState(() {
      emojiCounts[scrapIndex][emojiIndex]++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Following'),
      ),
      body: ListView.builder(
        itemCount: scrapData.length,
        itemBuilder: (context, index) {
          final item = scrapData[index];
          // null 체크 주석 추가
          final profileImage = item["profileImage"] ?? 'assets/images/default.png';
          final profileName = item["profileName"] ?? 'Unknown';
          final scrapContent = item["scrapContent"] ?? 'No content available';
          final scrapTime = item["scrapTime"] ?? 'Unknown time';
          final link = item["link"];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(profileImage),
                          radius: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          profileName,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      scrapContent,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      scrapTime,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        if (link != null && await canLaunch(link)) {
                          await launch(link);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch $link')),
                          );
                        }
                      },
                      child: Text(
                        link ?? 'No link available',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 8),
                    // 이모티콘 섹션 추가
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.sentiment_very_satisfied),
                          onPressed: () => _incrementEmoji(index, 0),
                        ),
                        Text('${emojiCounts[index][0]}'),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.sentiment_dissatisfied),
                          onPressed: () => _incrementEmoji(index, 1),
                        ),
                        Text('${emojiCounts[index][1]}'),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.sentiment_satisfied),
                          onPressed: () => _incrementEmoji(index, 2),
                        ),
                        Text('${emojiCounts[index][2]}'),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.sentiment_very_dissatisfied),
                          onPressed: () => _incrementEmoji(index, 3),
                        ),
                        Text('${emojiCounts[index][3]}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Following(),
  ));
}
