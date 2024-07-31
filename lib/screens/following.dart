import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/user_provider.dart'; // UserProvider 임포트 추가
import '../../services/scrap_service.dart'; // ScrapService 임포트 추가

class Following extends StatefulWidget {
  const Following({Key? key}) : super(key: key);

  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  List<Map<String, dynamic>> scrapData = [];

  @override
  void initState() {
    super.initState();
    _fetchScrapData();
  }

  // 팔로우한 사용자의 스크랩 데이터를 가져오는 메서드
  Future<void> _fetchScrapData() async {
    try {
      final scraps = await ScrapService().fetchScrapsByFollowing(context);
      setState(() {
        scrapData = scraps.cast<Map<String, dynamic>>();
        print(scrapData); // 디버깅 출력 추가
      });
    } catch (e) {
      print('Failed to fetch following scraps: $e');
    }
  }

  void _incrementEmoji(int scrapIndex, String emojiKey) {
    setState(() {
      scrapData[scrapIndex]["reactions"][emojiKey] =
          (scrapData[scrapIndex]["reactions"][emojiKey] ?? 0) + 1;
    });
  }

  IconData _getEmojiIcon(String emoji) {
    switch (emoji) {
      case "sentiment_very_satisfied":
        return Icons.sentiment_very_satisfied;
      case "sentiment_satisfied":
        return Icons.sentiment_satisfied;
      case "sentiment_dissatisfied":
        return Icons.sentiment_dissatisfied;
      case "sentiment_very_dissatisfied":
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar 배경색을 흰색으로 설정
        elevation: 0, // 그림자 효과를 제거
        title: Text(
          'Following',
          style: TextStyle(color: Colors.black), // 제목 텍스트 색상
        ),
      ),
      backgroundColor: Colors.white, // body 배경색을 흰색으로 설정
      body: ListView.builder(
        itemCount: scrapData.length,
        itemBuilder: (context, index) {
          final item = scrapData[index];
          final profileImage = item["profileImage"] ?? 'assets/images/default.png';
          final profileName = item["profileName"] ?? 'Unknown';
          final scrapContent = item["scrapContent"] ?? 'No content available';
          final scrapTime = item["createdAt"] ?? 'Unknown time'; // createdAt 필드 사용
          final link = item["url"] ?? ''; // url 필드 사용
          final emoji = item["emoji"] ?? 'sentiment_neutral';
          final reactions = item["reactions"] ?? {};

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.grey[300], // 카드 배경색을 회색으로 설정
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(profileImage), // 네트워크 이미지 사용
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
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300), // Optional: border color
                      ),
                      child: Text(
                        scrapContent,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          scrapTime,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Icon(
                          _getEmojiIcon(emoji),
                          size: 14,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        if (link.isNotEmpty && await canLaunchUrl(Uri.parse(link))) {
                          await launchUrl(Uri.parse(link));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch $link')),
                          );
                        }
                      },
                      child: Text(
                        '원문 링크 바로가기>>',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 8),
                    // 이모티콘 섹션 추가
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.sentiment_very_satisfied),
                          onPressed: () => _incrementEmoji(index, "sentiment_very_satisfied"),
                        ),
                        Text('${reactions["sentiment_very_satisfied"] ?? 0}'),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.sentiment_satisfied),
                          onPressed: () => _incrementEmoji(index, "sentiment_satisfied"),
                        ),
                        Text('${reactions["sentiment_satisfied"] ?? 0}'),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.sentiment_dissatisfied),
                          onPressed: () => _incrementEmoji(index, "sentiment_dissatisfied"),
                        ),
                        Text('${reactions["sentiment_dissatisfied"] ?? 0}'),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.sentiment_very_dissatisfied),
                          onPressed: () => _incrementEmoji(index, "sentiment_very_dissatisfied"),
                        ),
                        Text('${reactions["sentiment_very_dissatisfied"] ?? 0}'),
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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        home: Following(),
      ),
    ),
  );
}





/*

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Following extends StatefulWidget {
  const Following({Key? key}) : super(key: key);

  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  final List<Map<String, dynamic>> scrapData = [
    {
      "profileName": "크랩이",
      "scrapContent": "\"시원하네\" 한국 남자 양궁 단체, 현격한 기량 차이 꺾고 4강 진출. 일본은 대한민국의 상대가 되지 못했다. 큰 위기조차 없이 경기가 끝났다.",
      "scrapTime": "2024.7.29 10:00 PM",
      "link": "https://www.fnnews.com/news/202407292153475630",
      "profileImage": "assets/images/crabi.png",
      "emoji": "sentiment_very_satisfied",
      "reactions": {
        "sentiment_very_satisfied": 0,
        "sentiment_satisfied": 0,
        "sentiment_dissatisfied": 0,
        "sentiment_very_dissatisfied": 1,
      }
    },
    {
      "profileName": "크랩이3678abc",
      "scrapContent": "\"시원하네\" 한국 남자 양궁 단체, 현격한 기량 차이 꺾고 4강 진출. 일본은 대한민국의 상대가 되지 못했다. 큰 위기조차 없이 경기가 끝났다.",
      "scrapTime": "2024.7.29 10:00 PM",
      "link": "https://www.fnnews.com/news/202407292153475630",
      "profileImage": "assets/images/newsQrab.jpg",
      "emoji": "sentiment_very_dissatisfied",
      "reactions": {
        "sentiment_very_satisfied": 0,
        "sentiment_satisfied": 1,
        "sentiment_dissatisfied": 0,
        "sentiment_very_dissatisfied": 0,
      }
    }
  ];

  // 이모티콘 카운트를 관리하는 리스트
  List<List<int>> emojiCounts = [];

  @override
  void initState() {
    super.initState();
    // 각 스크랩에 대해 이모티콘 카운트 초기화
    emojiCounts = List.generate(scrapData.length, (index) => [
      scrapData[index]["reactions"]["sentiment_very_satisfied"] as int,
      scrapData[index]["reactions"]["sentiment_satisfied"] as int,
      scrapData[index]["reactions"]["sentiment_dissatisfied"] as int,
      scrapData[index]["reactions"]["sentiment_very_dissatisfied"] as int,
    ]);
  }

  void _incrementEmoji(int scrapIndex, int emojiIndex) {
    setState(() {
      emojiCounts[scrapIndex][emojiIndex]++;
    });
  }

  IconData _getEmojiIcon(String emoji) {
    switch (emoji) {
      case "sentiment_very_satisfied":
        return Icons.sentiment_very_satisfied;
      case "sentiment_satisfied":
        return Icons.sentiment_satisfied;
      case "sentiment_dissatisfied":
        return Icons.sentiment_dissatisfied;
      case "sentiment_very_dissatisfied":
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar 배경색을 흰색으로 설정
        elevation: 0, // 그림자 효과를 제거
        title: Text(
          'Following',
          style: TextStyle(color: Colors.black), // 제목 텍스트 색상
        ),
      ),
      backgroundColor: Colors.white, // body 배경색을 흰색으로 설정
      body: ListView.builder(
        itemCount: scrapData.length,
        itemBuilder: (context, index) {
          final item = scrapData[index];
          final profileImage = item["profileImage"] ?? 'assets/images/default.png';
          final profileName = item["profileName"] ?? 'Unknown';
          final scrapContent = item["scrapContent"] ?? 'No content available';
          final scrapTime = item["scrapTime"] ?? 'Unknown time';
          final link = item["link"] ?? '';
          final emoji = item["emoji"] ?? 'sentiment_neutral';

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.grey[300], // 카드 배경색을 회색으로 설정
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
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300), // Optional: border color
                      ),
                      child: Text(
                        scrapContent,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          scrapTime,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Icon(
                          _getEmojiIcon(emoji),
                          size: 14,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        if (link.isNotEmpty && await canLaunchUrl(Uri.parse(link))) {
                          await launchUrl(Uri.parse(link));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch $link')),
                          );
                        }
                      },
                      child: Text(
                        '원문 링크 바로가기>>',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 8),
                    // 이모티콘 섹션 추가
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.sentiment_very_satisfied),
                          onPressed: () => _incrementEmoji(index, 0),
                        ),
                        Text('${emojiCounts[index][0]}'),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.sentiment_satisfied),
                          onPressed: () => _incrementEmoji(index, 1),
                        ),
                        Text('${emojiCounts[index][1]}'),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.sentiment_dissatisfied),
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
} */
