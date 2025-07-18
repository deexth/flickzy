import 'package:flutter/material.dart';

class Continue extends StatelessWidget {
  const Continue({
    super.key,
    required this.newScreen,
    required this.isNewScreen,
  });

  final Widget newScreen;
  final bool isNewScreen;

  void _navigation(bool isNewScreen, BuildContext context) {
    if (isNewScreen) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => newScreen),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => newScreen));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          _navigation(isNewScreen, context);
        },

        child: const Text(
          'Continue',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
