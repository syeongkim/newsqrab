import 'package:flutter/material.dart';
import 'explore_sections/hotscrap_section.dart';
import 'explore_sections/kingcrab_section.dart';
import 'explore_sections/search_section.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SearchSection(), // 검색 섹션
                const KingCrabSection(), // 킹크랩 섹션
                const HotScrapSection(), // 핫스크랩 섹션
              ],
            ),
          ),
        ],
      ),
    );
  }
}
