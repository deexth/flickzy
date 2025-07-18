import 'package:flickzy/data/theme.dart';
import 'package:flickzy/features/auth/auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      themeMode: ThemeMode.system,

      // theme: TAppTheme.lightTheme,
      // darkTheme: TAppTheme.darkTheme,
      home: const AuthScreen(),
    );
  }
}
