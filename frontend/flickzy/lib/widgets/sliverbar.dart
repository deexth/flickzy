import 'package:flutter/material.dart';

class MySliverAppBar extends StatefulWidget {
  const MySliverAppBar({super.key});

  @override
  State<StatefulWidget> createState() => _MySliverAppBar();
}

class _MySliverAppBar extends State<MySliverAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.blueAccent,
      // pinned: true,
      expandedHeight: 20,

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: InkWell(
            onTap: () {},
            // radius: 22,
            customBorder: CircleBorder(),
            // borderRadius: BorderRadius.circular(10),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: const NetworkImage(
                'https://docs.flutter.dev/cookbook/img-files/effects/split-check/Avatar1.jpg',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
// IconButton(
//         icon: const Icon(Icons.menu_rounded),
//         onPressed: () {},
//       ),