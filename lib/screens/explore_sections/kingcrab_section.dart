import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/scrap_service.dart'; // ScrapService 임포트 추가
import '../../services/user_provider.dart'; // UserProvider 임포트 추가
import 'package:url_launcher/url_launcher.dart';
class KingCrabSection extends StatefulWidget {
  const KingCrabSection({super.key});

  @override
  _KingCrabSectionState createState() => _KingCrabSectionState();
}

class _KingCrabSectionState extends State<KingCrabSection> {
  List<Map<String, dynamic>> topUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchTopUsers();
  }

  // 팔로워 수가 많은 유저들을 가져오는 메서드
  Future<void> _fetchTopUsers() async {
    try {
      final users = await ScrapService().fetchTopUsers();
      setState(() {
        topUsers = users.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print('Failed to fetch top users: $e');
    }
  }

  Widget _buildKingCrabProfile(BuildContext context, Map<String, dynamic> user) {
    String profileImage = user['profileImage'] ?? 'default_profile_image_url';
    String nickname = user['nickname'] ?? 'Unknown User';
    String bio = user['bio'] ?? 'No bio available';
    String followUserId = user['_id']; // 팔로우할 유저의 ID

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0), // 프로필 간의 간격 추가
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _showUserDialog(context, followUserId, profileImage, nickname, bio);
            },
            child: CircleAvatar(
              radius: 45.0, // 원형 아바타 크기 증가
              backgroundImage: NetworkImage(profileImage),
            ),
          ),
          SizedBox(height: 8.0), // 원형 아바타와 버튼 사이의 간격
          Text(nickname),
          FollowButton(followUserId: followUserId), // FollowButton에 followUserId 전달
        ],
      ),
    );
  }

  void _showUserDialog(BuildContext context, String userId, String profileImage, String nickname, String bio) async {
    List<dynamic> scrapData = [];

    try {
      // 스크랩 데이터를 가져옴
      final scraps = await ScrapService().fetchScrapsByUserNickname(context);
      scrapData = scraps.where((scrap) => scrap['userId'] == userId).toList();
    } catch (e) {
      print('Failed to fetch user scraps: $e');
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profileImage),
              radius: 40,
            ),
            SizedBox(height: 8),
            Text(nickname, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(bio, style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: scrapData.length,
            itemBuilder: (context, index) {
              final item = scrapData[index];
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(item['title'] ?? 'No Content'),
                  subtitle: Text(item['createdAt'] ?? 'No Time'),
                  onTap: () {
                    _showDetailDialog(context, item);
                  },
                ),
              );
            },
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            'Popular KingCrab',
            style: TextStyle(
              fontSize: 20.0, // 원하는 글자 크기
            ),
          ),
        ),
        Container(
          height: 150,
          child: topUsers.isEmpty
              ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 표시
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: topUsers.length,
            itemBuilder: (context, index) {
              return _buildKingCrabProfile(context, topUsers[index]);
            },
          ),
        ),
      ],
    );
  }
}

class FollowButton extends StatefulWidget {
  final String followUserId;

  const FollowButton({Key? key, required this.followUserId}) : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadFollowingStatus();
  }

  // 로컬 저장소에서 팔로우 상태를 불러오는 메서드
  Future<void> _loadFollowingStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFollowing = prefs.getBool(widget.followUserId) ?? false;
    });
  }

  // 로컬 저장소에 팔로우 상태를 저장하는 메서드
  Future<void> _saveFollowingStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(widget.followUserId, isFollowing);
  }

  Future<void> _toggleFollow() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.userId!;

    try {
      if (isFollowing) {
        // 언팔로우
        await ScrapService().deleteFollowing(userId, widget.followUserId);
      } else {
        // 팔로우
        await ScrapService().updateFollowing(userId, widget.followUserId);
      }
      setState(() {
        isFollowing = !isFollowing;
        _saveFollowingStatus(); // 상태를 로컬에 저장
      });
    } catch (e) {
      print('Failed to update following: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // 버튼의 고정 가로 길이
      height: 30, // 버튼의 고정 세로 길이
      child: ElevatedButton(
        onPressed: _toggleFollow,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // 파란색 버튼
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // 둥근 모서리
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // 버튼 크기 조절
          textStyle: TextStyle(
            color: Colors.white, // 텍스트 색상 흰색
            fontSize: 14.0, // 텍스트 크기
          ),
        ),
        child: Text(isFollowing ? 'Following' : 'Follow',
            style: TextStyle(color: Colors.white)), // 텍스트 색상 흰색
      ),
    );
  }
}
