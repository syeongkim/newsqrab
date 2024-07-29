import 'package:flutter/material.dart';

class HotScrapSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Image.asset('assets/images/newsQrab.jpg'),
          title: Text('Hottest Scarps'),
        ),
        Container(
          height: 150,
          child: ListView(
            children: [
              _buildHotScrapItem(context, '빈항목1'),
              _buildHotScrapItem(context, '빈항목2'),
              _buildHotScrapItem(context, '빈항목3'),
              _buildHotScrapItem(context, '빈항목4'),
              _buildHotScrapItem(context, '빈항목5'),
              _buildHotScrapItem(context, '빈항목6'),
              _buildHotScrapItem(context, '빈항목7'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHotScrapItem(BuildContext context, String title) {
    return ListTile(
      title: Text(title),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('$title의 상세 정보'),
          ),
        );
      },
    );
  }
}
