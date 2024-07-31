import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Myclip extends StatefulWidget {
  const Myclip({Key? key}) : super(key: key);

  @override
  _MyclipState createState() => _MyclipState();
}

class _MyclipState extends State<Myclip> {
  String bio = "나는 mz경제전문가";
  String nickname = "크랩이";
  final List<Map<String, dynamic>> scrapData = [
    {
      "scrapContent": "\"시원하네\" 한국 남자 양궁 단체, 현격한 기량 차이 꺾고 4강 진출. 일본은 대한민국의 상대가 되지 못했다. 큰 위기조차 없이 경기가 끝났다.",
      "scrapTime": "2024.7.29 10:00 PM",
      "link": "https://www.fnnews.com/news/202407292153475630",
      "emoji": "sentiment_very_satisfied",
      "reactions": {
        "sentiment_very_satisfied": 0,
        "sentiment_satisfied": 0,
        "sentiment_dissatisfied": 0,
        "sentiment_very_dissatisfied": 1,
      }
    },
    {
      "scrapContent": "일본은 대한민국의 상대가 되지 못했다. 큰 위기조차 없이 경기가 끝났다.",
      "scrapTime": "2024.7.29 09:00 PM",
      "link": "https://www.fnnews.com/news/202407292153475630",
      "emoji": "sentiment_very_dissatisfied",
      "reactions": {
        "sentiment_very_satisfied": 0,
        "sentiment_satisfied": 1,
        "sentiment_dissatisfied": 0,
        "sentiment_very_dissatisfied": 0,
      }
    },
  ];

  final List<Map<String, String>> followingList = [
    {"name": "김예락", "profilePic": 'assets/images/crabi.png'},
    {"name": "김서영", "profilePic": 'assets/images/crabi.png'},
    {"name": "박영민", "profilePic": 'assets/images/crabi.png'},
  ];

  final List<Map<String, String>> followerList = [
    {"name": "김예락", "profilePic": 'assets/images/crabi.png'},
    {"name": "김서영", "profilePic": 'assets/images/crabi.png'},
    {"name": "박영민", "profilePic": 'assets/images/crabi.png'},
  ];

  // 추가된 상태 관리용 변수
  Map<String, bool> followingState = {
    "김예락": true,
    "김서영": true,
    "박영민": true,
  };

  Map<String, bool> followerState = {
    "김예락": true,
    "김서영": true,
    "박영민": true,
  };

  Future<void> _editField(String field) async {
    TextEditingController controller = TextEditingController(
      text: field == 'bio' ? bio : nickname,
    );
    String? updatedValue = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter new $field'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text('Save'),
          ),
        ],
      ),
    );

    setState(() {
      if (field == 'bio') {
        bio = updatedValue ?? bio;
      } else {
        nickname = updatedValue ?? nickname;
      }
    });
  }

  Future<void> _showDeleteDialog(int index) async {
    bool? delete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Scrap'),
        content: Text('Are you sure you want to delete this scrap?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (delete == true) {
      setState(() {
        scrapData.removeAt(index);
      });
    }
  }

  Future<void> _showDetailDialog(Map<String, dynamic> item) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Scrap Detail'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item["scrapContent"]),
            SizedBox(height: 8),
            Text(
              item["scrapTime"],
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final url = item["link"];
                if (await canLaunch(url)) {
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

  // 상태를 토글하는 함수
  void _toggleFollowingState(String name) {
    setState(() {
      followingState[name] = !(followingState[name] ?? false);
    });
  }

  void _toggleFollowerState(String name) {
    setState(() {
      followerState[name] = !(followerState[name] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: null,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onLongPress: () => _editField('bio'),
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/images/crabi.png'),
                            radius: 40,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onLongPress: () => _editField('nickname'),
                                child: Text(
                                  nickname,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 4),
                              GestureDetector(
                                onLongPress: () => _editField('bio'),
                                child: Text(
                                  bio,
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  ...scrapData.map((item) {
                    return GestureDetector(
                      onTap: () => _showDetailDialog(item),
                      onLongPress: () => _showDeleteDialog(scrapData.indexOf(item)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["scrapContent"],
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item["scrapTime"],
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  Icon(
                                    _getEmojiIcon(item["emoji"]),
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () async {
                                  final url = item["link"];
                                  if (await canLaunch(url)) {
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
                        ),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Following"),
                        SizedBox(height: 8),
                        ...followingList.map((following) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(following["profilePic"]!),
                                  radius: 20,
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(following["name"]!),
                                ),
                                Container(
                                  width: 60, // 버튼의 고정 가로 길이
                                  height: 30, // 버튼의 고정 세로 길이
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _toggleFollowingState(following["name"]!);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: (followingState[following["name"]!] ?? false) ? Colors.blue : Colors.grey, // 버튼 색상
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20), // 둥근 모서리
                                      ),
                                      padding: EdgeInsets.zero, // Padding을 제거하여 버튼 크기 줄이기
                                    ).copyWith(
                                      foregroundColor: MaterialStateProperty.all(Colors.white), // 텍스트 색상 변경
                                    ),
                                    child: Text((followingState[following["name"]!] ?? false) ? 'unfollow' : 'follow', style: TextStyle(fontSize: 12.0)), // 폰트 사이즈 조정
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        SizedBox(height: 20),
                        Text("Followers"),
                        SizedBox(height: 8),
                        ...followerList.map((follower) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(follower["profilePic"]!),
                                  radius: 20,
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(follower["name"]!),
                                ),
                                Container(
                                  width: 60, // 버튼의 고정 가로 길이
                                  height: 30, // 버튼의 고정 세로 길이
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _toggleFollowerState(follower["name"]!);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: (followerState[follower["name"]!] ?? false) ? Colors.blue : Colors.grey, // 버튼 색상
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20), // 둥근 모서리
                                      ),
                                      padding: EdgeInsets.zero, // Padding을 제거하여 버튼 크기 줄이기
                                    ).copyWith(
                                      foregroundColor: MaterialStateProperty.all(Colors.white), // 텍스트 색상 변경
                                    ),
                                    child: Text((followerState[follower["name"]!] ?? false) ? 'remove' : 'follow', style: TextStyle(fontSize: 12.0)), // 폰트 사이즈 조정
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildReactionIcon(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Text(count.toString(), style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
