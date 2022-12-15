import 'package:crocodile/customgame.dart';
import 'package:crocodile/gameboard.dart';
import 'package:crocodile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

// gameboard containing a number of items placed in a stack
class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    p1name = "Player 1";
    p2name = "Player 2";
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Image.asset(
                    "assets/crocodile_passive.png",
                    width: 300,
                    height: 200,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                          onPressed: () {
                            p1lives = 3;
                            p2lives = 3;
                            p1name = "Player 1";
                            p2name = "Player 2";
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const GameBoard()));
                          },
                          child: const Text("Quick Start")),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CustomGame()));
                          },
                          child: const Text("Custom Game")),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
