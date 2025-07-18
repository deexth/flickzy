import 'package:flickzy/widgets/postcard.dart';
import 'package:flickzy/widgets/sliverbar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> posts = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadInitialPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoadingMore) {
        _loadMorePosts();
      }
    });
  }

  Future<void> _loadInitialPosts() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      posts.addAll(List.generate(20, (index) => 'Post #$index'));
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      posts.insert(0, '✨ New Post at ${DateTime.now()}');
    });
  }

  Future<void> _loadMorePosts() async {
    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(Duration(seconds: 2)); // Fake API delay

    final nextIndex = posts.length;
    final morePosts = List.generate(
      10,
      (index) => 'Post #${nextIndex + index}',
    );

    setState(() {
      posts.addAll(morePosts);
      _isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("flickzy")),
      drawer: Drawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              MySliverAppBar(),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index < posts.length) {
                    return PostCard();
                  } else if (_isLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }, childCount: posts.length + (_isLoadingMore ? 1 : 0)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.home, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.messenger_rounded, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.play_arrow_outlined, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.window, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
