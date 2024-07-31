import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import '../../services/reels_service.dart';
import 'package:provider/provider.dart';
import '../../services/user_provider.dart';

class Reels extends StatefulWidget {
  const Reels({Key? key}) : super(key: key);

  @override
  _ReelsState createState() => _ReelsState();
}

class _ReelsState extends State<Reels> {
  List<dynamic> reels = [];
  bool isLoading = true;
  Map<int, VideoPlayerController> _controllers = {};
  final TextEditingController _commentController = TextEditingController();
  final ReelsService reelsService = ReelsService();

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
    final date = DateTime.now().subtract(Duration(days: 1));
    final dateString =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final url = Uri.parse('http://175.106.98.197:3000/reels/$dateString');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Fetched reels data: $data'); // 디버깅용 출력
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
          onPressed: () => showComments(context, reels[index]['_id'] ?? '',
              reels[index]['comments'] ?? []),
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

  void showComments(BuildContext context, String reelId, List<dynamic> comments) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext bc) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              padding: EdgeInsets.all(13),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        var comment = comments[index];
                        return CommentTile(
                          reelId: reelId,
                          commentId: comment['_id'] ?? '',
                          nickname: comment['nickname'] ?? 'Anonymous',
                          content: comment['content'] ?? '',
                          likes: comment['likes'] ?? 0,
                          reelsService: reelsService,
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
                        onPressed: () async {
                          final userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          final userId = userProvider.userId;
                          final nickname = userProvider.nickname;

                          try {
                            await reelsService.addComment(reelId, userId ?? '',
                                nickname ?? '', _commentController.text);
                            print("Submitted comment: ${_commentController.text}");

                            // 새로운 댓글을 리스트에 추가
                            setModalState(() {
                              comments.add({
                                '_id': '', // 서버에서 새로운 ID를 받기 전까지 빈 값으로 설정
                                'nickname': nickname,
                                'content': _commentController.text,
                                'likes': 0,
                              });
                            });

                            _commentController.clear();
                          } catch (e) {
                            print("Error adding comment: $e");
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
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
          SizedBox(height: 10),
          // 기존 비디오 리스트 로직
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: reels.length,
                    itemBuilder: (context, index) {
                      final reel = reels[index];
                      if (!_controllers.containsKey(index)) {
                        initializeVideoPlayer(index, reel['video'] ?? '');
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          title: Text(reel['title'] ?? ''),
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

class CommentTile extends StatefulWidget {
  final String reelId;
  final String commentId;
  final String nickname;
  final String content;
  final int likes;
  final ReelsService reelsService;

  const CommentTile({
    Key? key,
    required this.reelId,
    required this.commentId,
    required this.nickname,
    required this.content,
    required this.likes,
    required this.reelsService,
  }) : super(key: key);

  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  late int _likes;
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _likes = widget.likes;
    _isLiked = widget.likes > 0;
  }

  Future<void> _likeComment() async {
    try {
      await widget.reelsService.likeComment(widget.reelId, widget.commentId);
      setState(() {
        _likes += 1;
        _isLiked = true;
      });
    } catch (e) {
      print("Error liking comment: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.nickname),
      subtitle: Text(widget.content),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
            color: _isLiked ? Colors.red : null,
            onPressed: _isLiked ? null : _likeComment,
          ),
          Text('$_likes'),
        ],
      ),
    );
  }
}
