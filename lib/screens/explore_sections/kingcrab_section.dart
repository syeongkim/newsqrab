import 'package:flutter/material.dart';

class KingCrabSection extends StatelessWidget {
  const KingCrabSection({super.key});

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
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildKingCrabProfile(context, 'assets/images/newsQrab1.jpg'),
              _buildKingCrabProfile(context, 'assets/images/newsQrab2.jpg'),
              _buildKingCrabProfile(context, 'assets/images/newsQrab.jpg'),
              _buildKingCrabProfile(context, 'assets/images/newsQrab00.jpg'),
              _buildKingCrabProfile(context, 'assets/images/newsQrab000.jpg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKingCrabProfile(BuildContext context, String imagePath) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0), // 프로필 간의 간격 추가
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Image.asset(imagePath),
                ),
              );
            },
            child: CircleAvatar(
              radius: 45.0, // 원형 아바타 크기 증가
              backgroundImage: AssetImage(imagePath),
            ),
          ),
          SizedBox(height: 8.0), // 원형 아바타와 버튼 사이의 간격
          FollowButton(), // 원형 아바타 아래에 follow 버튼 추가
        ],
      ),
    );
  }
}

class FollowButton extends StatefulWidget {
  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // 버튼의 고정 가로 길이
      height: 30, // 버튼의 고정 세로 길이
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isFollowing = !isFollowing;
          });
        },
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
