import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // elevation: 2,
        _buildHeader(),
        const SizedBox(height: 2),
        _buildContent(),
        const SizedBox(height: 8),
        _buildImage(),
        const SizedBox(height: 8),

        _buildActions(),

        Divider(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: const NetworkImage(
              'https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar1.jpg',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Ali Kong", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Text(
                  "22 May · @alikong",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          TextButton(onPressed: () {}, child: const Text("Follow")),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: const Text(
        "Post description goes here. This is a sample tweet-like or Bluesky-style post content.",
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      // borderRadius: BorderRadius.circular(12),
      child: Image.network(
        'https://docs.flutter.dev/cookbook/img-files/effects/split-check/Food1.jpg',
        fit: BoxFit.cover,
        width: double.infinity,
        height: 320,
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.mode_comment_outlined),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.reply)),
          const Spacer(),
          IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
        ],
      ),
    );
  }
}
