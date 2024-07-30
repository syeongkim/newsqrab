import 'package:flutter/material.dart';
import 'package:newsqrap/services/naver_search_service.dart';

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
      setState(() {
        _results = results;
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
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_results[index]['title']),
                  subtitle: Text(_results[index]['description']),
                );
              },
            ),
          ),
        if (!_isLoading && _results.isEmpty && _error == null) const Text('검색 결과가 없습니다'),
      ],
    );
  }
}
