import 'package:flutter/material.dart';
import 'following.dart';
import 'explore.dart';
import 'scrap.dart';
import 'reels.dart';
import 'myclip.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // 탭의 개수
      child: Scaffold(
        appBar: AppBar(
          title: Text('메인 화면'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Following'),
              Tab(text: 'Explore'),
              Tab(text: 'Scrap'),
              Tab(text: 'Reels'),
              Tab(text: 'My Clip'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Following(), // Following 탭
            Explore(), // Explore 탭
            Scrap(), // Scrap 탭
            Reels(), // Reels 탭
            Myclip(), // My Clip 탭
          ],
        ),
      ),
    );
  }
}
