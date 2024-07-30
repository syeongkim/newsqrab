import 'package:flutter/material.dart';

class KingCrabSection extends StatelessWidget {
  const KingCrabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Image.asset('assets/images/newsQrab.jpg'),
          title: const Text('Popular KingCrab'),
        ),
        SizedBox(
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
