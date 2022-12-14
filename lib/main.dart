import 'package:crocodile/startscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

int p1lives = 3;
int p2lives = 3;
String p1name = "Player 1";
String p2name = "Player 2";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartScreen(),
    );
  }
}
