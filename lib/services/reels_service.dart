import 'dart:convert';
import 'package:http/http.dart' as http;

class ReelsService {
  final String baseUrl = 'http://13.124.11.216:3000/reels';

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

  // 소유자별로 릴스를 가져오는 메서드 추가
  Future<List<dynamic>> fetchReelsByOwner(String owner) async {
    final String url = '$baseUrl/owner/$owner';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load reels by owner');
    }
  }

  // 특정 ID로 기사를 가져오는 메서드 추가
  Future<dynamic> fetchArticleById(String articleId) async {
    final String url = 'http://13.124.11.216:3000/articles/$articleId'; // 기사 ID를 사용하여 URL을 구성
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // 응답을 JSON으로 디코딩
      } else {
        throw Exception('Failed to load article with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching article by ID: $e');
      throw Exception('Error fetching article by ID: $e');
    }
  }
}
