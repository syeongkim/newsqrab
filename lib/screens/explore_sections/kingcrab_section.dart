import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/scrap_service.dart';
import '../../services/user_provider.dart';
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
    String profileImage = user['profilePicture'] ?? 'https://kr.object.ncloudstorage.com/newsqrab/profiles/crabi.png';
    String nickname = user['nickname'] ?? 'Unknown User';
    String bio = user['bio'] ?? 'No bio available';
    String followUserId = user['_id'];

    bool isNetworkImage = profileImage.startsWith('http') || profileImage.startsWith('https');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _showUserDialog(context, followUserId, profileImage, nickname, bio);
            },
            child: CircleAvatar(
              radius: 45.0,
              backgroundImage: isNetworkImage ? NetworkImage(profileImage) : AssetImage(profileImage) as ImageProvider,
            ),
          ),
          SizedBox(height: 8.0),
          Text(nickname),
          FollowButton(followUserId: followUserId),
        ],
      ),
    );
  }

  void _showUserDialog(BuildContext context, String userId, String profileImage, String nickname, String bio) async {
    List<dynamic> scrapData = [];
    List<dynamic> followingList = [];
    List<dynamic> followerList = [];

    try {
      final scraps = await ScrapService().fetchScrapsByNickname(nickname); // 변경된 부분
      scrapData = scraps;

      final user = await ScrapService().fetchUserById(userId);
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
              backgroundImage: NetworkImage(profileImage),
              radius: 40,
            ),
            SizedBox(height: 8),
            Text(nickname, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(bio, style: TextStyle(fontSize: 16, color: Colors.grey)),
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
                  title: Text(item['highlightedText'] ?? 'No Content'),
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
            'Popular KingCrab',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        Container(
          height: 150,
          child: topUsers.isEmpty
              ? Center(child: CircularProgressIndicator())
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

  Future<void> _loadFollowingStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFollowing = prefs.getBool(widget.followUserId) ?? false;
    });
  }

  Future<void> _saveFollowingStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(widget.followUserId, isFollowing);
  }

  Future<void> _toggleFollow() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.userId!;

    try {
      if (isFollowing) {
        await ScrapService().deleteFollowing(userId, widget.followUserId);
      } else {
        await ScrapService().updateFollowing(userId, widget.followUserId);
      }
      setState(() {
        isFollowing = !isFollowing;
        _saveFollowingStatus();
      });
    } catch (e) {
      print('Failed to update following: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 30,
      child: ElevatedButton(
        onPressed: _toggleFollow,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE65C5C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
        child: Text(isFollowing ? 'Following' : 'Follow', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
