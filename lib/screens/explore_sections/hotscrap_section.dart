import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/user_provider.dart'; // UserProvider 임포트 추가
import '../../services/scrap_service.dart'; // ScrapService 임포트 추가

class HotScrapSection extends StatefulWidget {
  @override
  _HotScrapSectionState createState() => _HotScrapSectionState();
}

class _HotScrapSectionState extends State<HotScrapSection> {
  late Future<List<Map<String, dynamic>>> _hotScrapsFuture;
  List<List<int>> emojiCounts = []; // 각 스크랩 항목의 이모지 개수를 추적하기 위한 리스트
  String? userId;

  @override
  void initState() {
    super.initState();
    _hotScrapsFuture = fetchHotScraps();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = Provider.of<UserProvider>(context).userId;
  }

  Future<List<Map<String, dynamic>>> fetchHotScraps() async {
    final scrapService = ScrapService();
    final scraps = await scrapService.fetchHotScraps();
    // 스크랩 데이터의 각 항목마다 이모지 개수를 초기화
    emojiCounts = scraps.map((item) {
      final reactions = item["followerEmojis"] ?? [];
      int verySatisfiedCount = reactions.where((e) => e["emoji"] == "sentiment_very_satisfied").length;
      int satisfiedCount = reactions.where((e) => e["emoji"] == "sentiment_satisfied").length;
      int dissatisfiedCount = reactions.where((e) => e["emoji"] == "sentiment_dissatisfied").length;
      int veryDissatisfiedCount = reactions.where((e) => e["emoji"] == "sentiment_very_dissatisfied").length;
      return [verySatisfiedCount, satisfiedCount, dissatisfiedCount, veryDissatisfiedCount];
    }).toList();
    return scraps.cast<Map<String, dynamic>>(); // 타입 캐스팅
  }

  void _incrementEmoji(int scrapIndex, int emojiIndex) async {
    if (userId == null) {
      print('User ID is null');
      return;
    }

    final scrapId = (await _hotScrapsFuture)[scrapIndex]["_id"];
    final profileId = (await _hotScrapsFuture)[scrapIndex]["userId"];

    // 이모지 타입 설정
    String emoji;
    switch (emojiIndex) {
      case 0:
        emoji = "sentiment_very_satisfied";
        break;
      case 1:
        emoji = "sentiment_satisfied";
        break;
      case 2:
        emoji = "sentiment_dissatisfied";
        break;
      case 3:
        emoji = "sentiment_very_dissatisfied";
        break;
      default:
        emoji = "sentiment_neutral";
    }

    // API 호출하여 이모지 업데이트
    try {
      await ScrapService().updateFollowerEmoji(scrapId, userId!, emoji);
      setState(() {
        emojiCounts[scrapIndex][emojiIndex]++;
      });
    } catch (e) {
      print('Failed to update emoji: $e');
    }
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

  void _showPopup(BuildContext context, Map<String, dynamic> item) async {
    List<dynamic> followingList = [];
    List<dynamic> followerList = [];

    try {
      final user = await ScrapService().fetchUserById(item["userId"]);
      followingList = user.following;
      followerList = user.followers;
    } catch (e) {
      print('Failed to fetch user data: $e');
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(item['profileImage'] ?? 'assets/images/crabi.png'),
              radius: 40,
            ),
            SizedBox(height: 8),
            Text(
              item['usernickname'] ?? 'Unknown',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Text(
                          '팔로잉',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          followingList.length.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 32),
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Text(
                          '팔로워',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          followerList.length.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(item['highlightedText'] ?? 'No Content'),
                  subtitle: Text(item['createdAt'] ?? 'No Time'),
                  onTap: () {
                    _showDetailDialog(context, item);
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDetailDialog(BuildContext context, Map<String, dynamic> item) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Scrap Detail'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item["title"] ?? 'No Content'),
            SizedBox(height: 8),
            Text(
              item["createdAt"] ?? 'No Time',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final url = item["url"];
                if (url != null && await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Text(
                "원문보기",
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
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
                    final item = scrapData[index];
                    final profileImage = item["profileImage"] ?? 'assets/images/crabi.png';
                    final profileName = item["usernickname"] ?? 'Unknown';
                    final scrapContent = item["highlightedText"] ?? 'No content available';
                    final scrapTime = item["createdAt"] ?? 'Unknown time'; // createdAt 필드 사용
                    final link = item["url"] ?? ''; // url 필드 사용
                    final emoji = item["myemoji"] ?? 'sentiment_neutral';

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          _showPopup(context, item);
                        },
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
                                      backgroundImage: profileImage.startsWith('http')
                                          ? NetworkImage(profileImage)
                                          : AssetImage(profileImage) as ImageProvider,
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
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
