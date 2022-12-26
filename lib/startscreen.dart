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
    game.p1name = "Player 1";
    game.p2name = "Player 2";
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(208, 219, 219, 1),
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
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  width: 2, color: Colors.black)),
                          onPressed: () {
                            game.p1score = 3;
                            game.p2score = 3;
                            game.p1name = "Player 1";
                            game.p2name = "Player 2";
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const GameBoard()));
                          },
                          child: const Text("Quick Start",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  width: 2, color: Colors.black)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CustomGame()));
                          },
                          child: const Text("Custom Game",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
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
