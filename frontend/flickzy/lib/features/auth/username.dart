import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class ChooseUsername extends StatefulWidget {
  const ChooseUsername({super.key});

  @override
  State<StatefulWidget> createState() => _ChooseUsername();
}

class _ChooseUsername extends State<ChooseUsername> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: Center(child: Text(WordPair.random().asCamelCase))),
    );
  }
}
