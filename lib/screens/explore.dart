import 'package:flutter/material.dart';
import 'explore_sections/hotscrap_section.dart';
import 'explore_sections/kingcrab_section.dart';
import 'explore_sections/search_section.dart';

class Explore extends StatelessWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF), // 흰색
              Color(0xFFD3E2FF), // 연파랄
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SearchSection(), // 검색 섹션
                  KingCrabSection(), // 킹크랩 섹션
                  HotScrapSection(), // 핫스크랩 섹션
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
