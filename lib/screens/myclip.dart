import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/user_provider.dart'; // UserProvider 임포트 추가
import '../../services/scrap_service.dart';
import '../model/user_model.dart'; // ScrapService 임포트 추가

class Myclip extends StatefulWidget {
  const Myclip({Key? key}) : super(key: key);

  @override
  _MyclipState createState() => _MyclipState();
}

class _MyclipState extends State<Myclip> {
  String bio = ""; // 기본 bio 설정
  String nickname = ""; // 기본 닉네임 설정
  List<Map<String, dynamic>> scrapData = []; // 스크랩 데이터 리스트
  List<Map<String, String>> followingList = []; // 팔로잉 리스트
  List<Map<String, String>> followerList = []; // 팔로워 리스트

  @override
  void initState() {
    super.initState();
    print('initState called');
    _loadUserData();
    // _fetchUserNickname(); // 사용자 닉네임 불러오기
    _fetchScrapData(); // 스크랩 데이터 불러오기
  }

  // // 사용자 닉네임을 provider에서 가져오는 함수
  // void _fetchUserNickname() {
  //   final userProvider = context.read<UserProvider>();
  //   setState(() {
  //     nickname = userProvider.nickname ?? "Hello Crabi"; //기본값을 사용하여 null 가능성 제거
  //   });
  // }

  // 사용자 데이터를 서버에서 가져오는 함수
  Future<void> _loadUserData() async {
    try {
      final userProvider = context.read<UserProvider>();
      final userId = userProvider.userId;

      if (userId == null) {
        print('User ID is null');
        return;
      }

      User user = await ScrapService().fetchUserById(userId);

      setState(() {
        bio = user.bio;
        nickname = user.nickname;
        followingList = user.following.map((follower) => {
          "name": follower.name,
          "profilePic": follower.profilePic,
        }).toList();
        followerList = user.followers.map((follower) => {
          "name": follower.name,
          "profilePic": follower.profilePic,
        }).toList();
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
  // 스크랩 데이터를 서버에서 가져오는 함수
  Future<void> _fetchScrapData() async {
    try {
      final scraps = await ScrapService().fetchScrapsByUserNickname(context); // 스크랩 데이터 가져오기
      setState(() {
        scrapData = scraps.cast<Map<String, dynamic>>(); // 스크랩 데이터 설정
        print(scrapData); // 디버깅을 위해 데이터 출력
      });
    } catch (e) {
      print('Failed to fetch scraps: $e'); // 에러 처리
    }
  }

  // bio 또는 닉네임을 수정하는 함수
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

    if (updatedValue != null && updatedValue.isNotEmpty) {
      setState(() {
        if (field == 'bio') {
          bio = updatedValue; // bio 업데이트
        } else {
          nickname = updatedValue; // 닉네임 업데이트
        }
      });
    }
  }

  // 스크랩 데이터를 삭제할지 확인하는 함수
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
        scrapData.removeAt(index); // 스크랩 데이터 삭제
      });
    }
  }

  // 스크랩 데이터를 자세히 보여주는 함수
  Future<void> _showDetailDialog(Map<String, dynamic> item) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Scrap Detail'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item["title"] ?? 'No Content'), // 스크랩 제목
            SizedBox(height: 8),
            Text(
              item["createdAt"] ?? 'No Time', // 스크랩 시간
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final url = item["url"];
                if (url != null && await canLaunch(url)) {
                  await launch(url); // 링크 열기
                } else {
                  throw 'Could not launch $url'; // 에러 처리
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

  // 이모지에 따른 아이콘 반환 함수
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: scrapData.length, // 스크랩 데이터 개수
                    itemBuilder: (context, index) {
                      final item = scrapData[index];
                      final reactions = item["followEmojis"] ?? {}; // reactions가 null일 경우 빈 맵으로 설정
                      return GestureDetector(
                        onTap: () => _showDetailDialog(item), // 스크랩 상세 보기
                        onLongPress: () => _showDeleteDialog(index), // 스크랩 삭제
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["title"] ?? 'No Content',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  item["createdAt"] ?? 'No Time',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: reactions.entries.map<Widget>((entry) {
                                    return Chip(
                                      label: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _getEmojiIcon(entry.key),
                                            size: 16,
                                          ),
                                          SizedBox(width: 4),
                                          Text(entry.value.toString()),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(),



                ],
              ),
            ),
          ],
        ),
      ),



    );
  }
}