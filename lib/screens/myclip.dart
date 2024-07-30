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
        "sentiment_very_dissatisfied": 0,
      }
    },
    {
      "scrapContent": "\"시원하네\" 한국 남자 양궁 단체, 현격한 기량 차이 꺾고 4강 진출. 일본은 대한민국의 상대가 되지 못했다. 큰 위기조차 없이 경기가 끝났다.",
      "scrapTime": "2024.7.29 10:00 PM",
      "link": "https://www.fnnews.com/news/202407292153475630",
      "emoji": "sentiment_very_dissatisfied",
      "reactions": {
        "sentiment_very_satisfied": 0,
        "sentiment_satisfied": 0,
        "sentiment_dissatisfied": 0,
        "sentiment_very_dissatisfied": 0,
      }
    },
  ];

  Future<void> _editField(String field) async {
    TextEditingController controller = TextEditingController(
      text: field == 'bio' ? bio : nickname,
    );
    String updatedValue = await showDialog(
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
        bio = updatedValue;
      } else {
        nickname = updatedValue;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar의 title을 제거
        title: null,
        // AppBar를 빈 공간으로 대체 (필요에 따라 preferredSize를 사용)
        toolbarHeight: 0, // AppBar의 높이를 0으로 설정
        elevation: 0, // 그림자 효과를 제거
      ),
      body: ListView(
        children: [
          // 프로필 정보 섹션
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
          // 스크랩 항목 리스트뷰
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: scrapData.length,
            itemBuilder: (context, index) {
              final item = scrapData[index];
              return GestureDetector(
                onTap: () => _showDetailDialog(item),
                onLongPress: () => _showDeleteDialog(index),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                size: 14, // 이모지를 본문 텍스트 크기와 맞춤
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
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildReactionIcon(
                                Icons.sentiment_very_satisfied,
                                item["reactions"]["sentiment_very_satisfied"],
                              ),
                              _buildReactionIcon(
                                Icons.sentiment_satisfied,
                                item["reactions"]["sentiment_satisfied"],
                              ),
                              _buildReactionIcon(
                                Icons.sentiment_dissatisfied,
                                item["reactions"]["sentiment_dissatisfied"],
                              ),
                              _buildReactionIcon(
                                Icons.sentiment_very_dissatisfied,
                                item["reactions"]["sentiment_very_dissatisfied"],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReactionIcon(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        SizedBox(width: 4),
        Text(count.toString(), style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Myclip(),
  ));
}
