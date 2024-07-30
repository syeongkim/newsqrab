import 'package:flutter/material.dart';
import 'package:newsqrap/services/naver_search_service.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(String url) async {
  // ignore: deprecated_member_use
  if (await canLaunch(url)) {
    // ignore: deprecated_member_use
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  _SearchSectionState createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final TextEditingController _controller = TextEditingController();
  final NaverSearchService _naverSearchService = NaverSearchService();
  List<dynamic> _results = [];
  bool _isLoading = false;
  String? _error;

  void _search() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await _naverSearchService.search(_controller.text);
      print('Fetched results: $results'); // 결과 로깅
      setState(() {
        _results = results; // 결과 상태 업데이트
        print('Updated results: $_results'); // 상태 업데이트 후 로깅
      });
    } catch (e) {
      setState(() {
        _error = '검색에 실패했습니다. 다시 시도해 주세요. 에러: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: '검색어를 입력하세요'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _search,
              ),
            ],
          ),
        ),
        if (_isLoading) const CircularProgressIndicator(),
        if (_error != null) Text(_error!),
        if (_results.isNotEmpty)
          Container(
            height: 300, // 일정 높이 지정
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_results[index]['title']),
                  subtitle: Text(_results[index]['description']),
                  onTap: () => _launchUrl(_results[index]['link']),
                );
              },
            ),
          ),
        if (!_isLoading && _results.isEmpty && _error == null)
          Text('검색 결과가 없습니다'),
      ],
    );
  }
}
