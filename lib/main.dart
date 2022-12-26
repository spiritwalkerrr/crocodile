import 'package:crocodile/startscreen.dart';
import 'package:flutter/material.dart';

import 'game.dart';

Game game = Game();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: const StartScreen(),
    );
  }
}
