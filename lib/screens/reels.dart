import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';

class Reels extends StatefulWidget {
  const Reels({Key? key}) : super(key: key);

  @override
  _ReelsState createState() => _ReelsState();
}

class _ReelsState extends State<Reels> {
  List<dynamic> reels = [];
  bool isLoading = true;
  Map<int, VideoPlayerController> _controllers = {};

  @override
  void initState() {
    super.initState();
    fetchReels();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> fetchReels() async {
    final date = DateTime.now();
    final dateString =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final url = Uri.parse('http://143.248.195.18:3000/reels/$dateString');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          reels = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load reels');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildVideoWidget(int index) {
    VideoPlayerController controller = _controllers[index]!;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // 터치 시 재생 상태 토글
            setState(() {
              controller.value.isPlaying
                  ? controller.pause()
                  : controller.play();
            });
          },
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(controller),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: !controller.value.isPlaying
                      ? Container(
                          color: Colors.black54,
                          child: Icon(Icons.play_arrow,
                              size: 50, color: Colors.white),
                        )
                      : SizedBox.shrink(), // 재생 중이면 아무것도 보여주지 않음
                ),
              ],
            ),
          ),
        ),
        // 댓글 버튼 추가
        TextButton(
          onPressed: () => showComments(context, reels[index]['comments']),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Row의 크기를 자식 요소에 맞춤
            children: [
              Icon(Icons.comment, color: Colors.black), // 댓글 아이콘
              SizedBox(width: 4), // 아이콘과 텍스트 사이의 간격
            ],
          ),
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        )
      ],
    );
  }

  void togglePlay(int index) {
    if (_controllers[index] != null) {
      setState(() {
        if (_controllers[index]!.value.isPlaying) {
          _controllers[index]!.pause();
        } else {
          _controllers[index]!.play();
        }
      });
    }
  }

  void initializeVideoPlayer(int index, String url) {
    print('Initializing video player for $url');
    var controller = VideoPlayerController.network(url);

    controller.initialize().then((_) {
      if (mounted) {
        setState(() {
          _controllers[index] = controller;
        });
      }
    }).catchError((err) {
      print('Error initializing video player: $err');
    });
  }

  void showComments(BuildContext context, List<dynamic> comments) {
    TextEditingController _commentController = TextEditingController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // 키보드가 화면을 가리지 않도록
        builder: (BuildContext bc) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets, // 키보드에 의해 조정되는 패딩
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              padding: EdgeInsets.all(13),
              child: Column(
                mainAxisSize: MainAxisSize.min, // 컨텐츠 크기에 맞게 최소화
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        var comment = comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(comment['userId']
                                    ['profilePicture'] ??
                                'assets/images/default_avatar.png'), // 가상의 URL or 기본 이미지
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black,
                          ),
                          title: Text(comment['nickname'] ?? 'Anonymous'),
                          subtitle: Text(comment['content']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.favorite_border),
                              Text('${comment['likes']}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          // TODO: 댓글 제출 로직 구현
                          print(
                              "Submitted comment: ${_commentController.text}");
                          // 필요한 경우 댓글을 서버에 보내고 리스트를 업데이트
                          _commentController.clear();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 13),
          // 가로 스크롤 버튼 리스트
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0), // 양 옆에 패딩 적용
            child: Container(
              height: 100, // 버튼과 레이블을 포함할 충분한 높이 제공
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buttonItem(
                      'assets/images/crabi.png', "NewsQrab", Colors.white),
                  buttonItem(
                      'assets/images/herald.png', "헤럴드 경제", Colors.white),
                  buttonItem(
                      'assets/images/choseon.png', "조선 일보", Colors.white),
                  buttonItem(
                      'assets/images/sportsChoseon.png', "스포츠조선", Colors.white),
                  buttonItem('assets/images/ytn.png', "YTN", Colors.white),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          // 기존 비디오 리스트 로직
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: reels.length,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemBuilder: (context, index) {
                      final reel = reels[index];
                      if (!_controllers.containsKey(index)) {
                        initializeVideoPlayer(index, reel['video']);
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          subtitle: _controllers.containsKey(index) &&
                                  _controllers[index]!.value.isInitialized
                              ? buildVideoWidget(index)
                              : Container(
                                  height: 200,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget buttonItem(String imagePath, String label, Color bgColor) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              print("$label tapped");
            },
            child: Image.asset(imagePath, width: 24, height: 24), // 이미지 크기 조절
            backgroundColor: bgColor,
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
