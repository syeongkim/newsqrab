import 'dart:convert';
import 'package:http/http.dart' as http;

class ReelsService {
  final String baseUrl = 'http://175.106.98.197:3000/reels';

  // 댓글을 추가하는 메서드
  Future<void> addComment(String reelId, String userId, String nickname, String content, {String? profilePicture}) async {
    final String url = '$baseUrl/$reelId/comments';
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'userId': userId,
        'nickname': nickname,
        'content': content,
        'profilePicture': profilePicture,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add comment');
    }
  }

  // 정렬된 댓글을 가져오는 메서드
  Future<List<dynamic>> getCommentsSorted(String reelId) async {
    final String url = '$baseUrl/$reelId/comments/sorted';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load sorted comments');
    }
  }

  // 댓글에 좋아요를 추가하는 메서드
  Future<void> likeComment(String reelId, String commentId) async {
    final String url = '$baseUrl/$reelId/comments/$commentId/like';
    print('Sending PUT request to $url'); // URL 로그 출력
    final response = await http.put(
      Uri.parse(url),
    );

    // 상태 코드와 응답 본문 출력
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to like comment: ${response.body}');
    }
  }
}
