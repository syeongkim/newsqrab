import 'dart:convert';
import 'package:http/http.dart' as http;

class NaverSearchService {
  final String clientId = 'aaXPorWySR6meonUUIEH';
  final String clientSecret = 'dWxNuP5F9V';

  Future<List<dynamic>> search(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://openapi.naver.com/v1/search/news.json?query=${Uri.encodeComponent(query)}'),
      headers: {
        'X-Naver-Client-Id': clientId,
        'X-Naver-Client-Secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['items'];
    } else {
      print(
          'Failed to load search results. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load search results');
    }
  }
}
