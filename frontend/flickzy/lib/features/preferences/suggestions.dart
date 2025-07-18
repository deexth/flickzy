import 'package:flickzy/data/example.dart';
import 'package:flickzy/features/home/home.dart';
import 'package:flickzy/widgets/accounts.dart';
import 'package:flickzy/widgets/genres.dart';
import 'package:flickzy/widgets/continue_button.dart';
import 'package:flutter/material.dart';

class Suggestions extends StatefulWidget {
  const Suggestions({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Suggestions();
  }
}

class _Suggestions extends State<Suggestions> {
  final userAccounts = demoSuggestions;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 20, top: 8),
          child: ImageIcon(AssetImage('assets/icons/target.png')),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              Text(
                'Suggested Accounts',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[900],
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              GenreList(accountGenres: userAccounts),
              Divider(),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.54,
                child: SuggestedAccounts(accounts: userAccounts),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Continue(newScreen: HomeScreen(), isNewScreen: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
