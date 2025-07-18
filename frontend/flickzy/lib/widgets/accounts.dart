import 'package:cached_network_image/cached_network_image.dart';
import 'package:flickzy/data/models.dart';
import 'package:flutter/material.dart';

class SuggestedAccounts extends StatefulWidget {
  const SuggestedAccounts({super.key, required this.accounts});

  final List<Demographics> accounts;

  @override
  State<StatefulWidget> createState() {
    return _SuggestedAccounts();
  }
}

class _SuggestedAccounts extends State<SuggestedAccounts> {
  final bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    final List<Demographics> accounts = widget.accounts;
    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        return ListTile(
          leading: ClipOval(
            child: CachedNetworkImage(
              imageUrl: account.avatarUrl,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(account.fullName),
          subtitle: Text(
            '@${account.userName}\n${account.bioText}',
            maxLines: 2,
          ),
          trailing: ElevatedButton(onPressed: () {}, child: Text("Follow")),
        );
      },
    );
  }
}
