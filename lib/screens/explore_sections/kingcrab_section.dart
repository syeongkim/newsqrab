import 'package:flutter/material.dart';

class KingCrabSection extends StatelessWidget {
  const KingCrabSection({super.key});

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
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Image.asset(imagePath),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 40, // 원하는 원형 크기
          backgroundImage: AssetImage(imagePath),
        ),
      ),
    );
  }
}

