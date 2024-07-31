@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white, // AppBar 배경색을 흰색으로 설정
      elevation: 0, // 그림자 효과를 제거
      title: Text(
        'Following',
        style: TextStyle(color: Colors.black), // 제목 텍스트 색상
      ),
    ),
    backgroundColor: Colors.white, // body 배경색을 흰색으로 설정
    body: ListView.builder(
      itemCount: scrapData.length,
      itemBuilder: (context, index) {
        final item = scrapData[index];
        final profileImage = item["profileImage"] ?? 'assets/images/crabi.png';
        final profileName = item["usernickname"] ?? 'Unknown';
        final scrapContent = item["highlightedText"] ?? 'No content available';
        final scrapTime = item["createdAt"] ?? 'Unknown time'; // createdAt 필드 사용
        final link = item["url"] ?? ''; // url 필드 사용
        final emoji = item["myemoji"] ?? 'sentiment_neutral';

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              _showPopup(context, item);
            },
            child: Card(
              color: Colors.grey[300], // 카드 배경색을 회색으로 설정
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: profileImage.startsWith('http')
                              ? NetworkImage(profileImage)
                              : AssetImage(profileImage) as ImageProvider,
                          radius: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          profileName,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300), // Optional: border color
                      ),
                      child: Text(
                        scrapContent,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          scrapTime,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Icon(
                          _getEmojiIcon(emoji),
                          size: 14,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        if (link.isNotEmpty && await canLaunchUrl(Uri.parse(link))) {
                          await launchUrl(Uri.parse(link));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch $link')),
                          );
                        }
                      },
                      child: Text(
                        '원문 링크 바로가기>>',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 8),
                    // 이모티콘 섹션 추가
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.sentiment_very_satisfied),
                          onPressed: () => _incrementEmoji(index, 0),
                        ),
                        Text('${emojiCounts[index][0]}'),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.sentiment_satisfied),
                          onPressed: () => _incrementEmoji(index, 1),
                        ),
                        Text('${emojiCounts[index][1]}'),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.sentiment_dissatisfied),
                          onPressed: () => _incrementEmoji(index, 2),
                        ),
                        Text('${emojiCounts[index][2]}'),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(Icons.sentiment_very_dissatisfied),
                          onPressed: () => _incrementEmoji(index, 3),
                        ),
                        Text('${emojiCounts[index][3]}'),
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
  );
}
