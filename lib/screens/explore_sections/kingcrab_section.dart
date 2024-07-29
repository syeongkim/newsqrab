import 'package:flutter/material.dart';

class KingCrabSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Image.asset(
            'assets/images/newsQrab.jpg',
            width: 25.0, // 원하는 가로 크기로 변경
            height: 25.0, // 원하는 세로 크기로 변경
          ),
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
        child: Image.asset(imagePath),
      ),
    );
  }
}
