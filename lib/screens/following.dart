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
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
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
              ),
            ],
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
    return Scaffold(
      appBar: AppBar(
        title: null, // AppBar의 title을 제거
        toolbarHeight: 0, // AppBar의 높이를 0으로 설정
        elevation: 0, // 그림자 효과를 제거
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
