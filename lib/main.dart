import 'package:flutter/material.dart';
import 'following.dart';
import 'explore.dart';
import 'scrap.dart';
import 'reels.dart';
import 'myclip.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,  // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const TabBarView(
          children: [
            Following(),
            Explore(),
            Scrap(),
            Reels(),
            Myclip(),
          ],
        ),
        bottomNavigationBar: Material(
          color: Colors.white, // Adjust the color as needed
          child: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'Follwing'),
              Tab(icon: Icon(Icons.explore), text: 'Explore'),
              Tab(icon: Icon(Icons.create), text: 'Scrap'),
              Tab(icon: Icon(Icons.video_library), text: 'Reels'),
              Tab(icon: Icon(Icons.folder), text: 'Myclip'),
            ],
            indicatorSize: TabBarIndicatorSize.label, // Makes indicator full width of the tab
          ),
        ),
      ),
    );
  }
}
