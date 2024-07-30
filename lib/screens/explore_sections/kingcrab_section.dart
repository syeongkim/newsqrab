import 'package:flutter/material.dart';

class KingCrabSection extends StatelessWidget {
  // 더미 데이터: 각 이미지와 유저 이름을 리스트로 관리
  final List<Map<String, String>> userData = [
    {'image': 'assets/images/newsQrab.jpg', 'name': 'User 1'},
    {'image': 'assets/images/newsQrab.jpg', 'name': 'User 2'},
    {'image': 'assets/images/newsQrab.jpg', 'name': 'User 3'},
    {'image': 'assets/images/newsQrab.jpg', 'name': 'User 4'},
    {'image': 'assets/images/newsQrab.jpg', 'name': 'User 5'},
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
            'Popular KingCrab',
            style: TextStyle(
              fontSize: 20.0, // 원하는 글자 크기
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            height: 120, // 높이를 증가시켜 이름 표시 공간 확보
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: userData.length,
              itemBuilder: (context, index) {
                return _buildKingCrabProfile(
                  context,
                  userData[index]['image']!,
                  userData[index]['name']!,
                  100, // 이미지와 이름을 담은 컨테이너의 너비
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKingCrabProfile(
      BuildContext context, String imagePath, String userName, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // 이미지의 모서리를 둥글게 처리
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover, // 이미지를 컨테이너에 맞게 조정하고 필요한 부분을 자름
              width: 80, // 정사각형을 유지하기 위해 width와 height 동일하게 설정
              height: 80,
            ),
          ),
        ],
      ),
    );
  }
}
