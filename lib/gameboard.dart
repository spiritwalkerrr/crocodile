import 'package:crocodile/startscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "game.dart";
import "main.dart";

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

// gameboard containing a number of items placed in a stack
class _GameBoardState extends State<GameBoard> {
  late Game game;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    game = Game();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(40.0),
      child: AnimatedBuilder(
        animation: game,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 30,
                    width: 90,
                    child: generatep1scores(),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        game.alertText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      Text(
                        game.instructionText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 30,
                    width: 90,
                    child: generatep2scores(),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    // required to realise when we press / unpress
                    onTapDown: (details) {
                      game.p1press();
                    },
                    onTapUp: (details) {
                      game.p1unpress();
                      // game.p2unpress(); // todo: remove this
                    },
                    child: Image.asset(
                      "assets/meat.jpeg",
                      width: 80,
                      height: 80,
                    ),
                  ),
                  Expanded(
                    child: AnimatedAlign(
                      alignment: game.crocAlignment,
                      duration: const Duration(milliseconds: 600),
                      onEnd: () => game.checkWin(),
                      curve: Curves.easeInExpo,
                      child: AnimatedRotation(
                        duration: const Duration(milliseconds: 500),
                        turns: game.currentRotation.toDouble() / 180,
                        child: Image.asset(
                          game.aggressive == true
                              ? "assets/crocodile_angry.png"
                              : "assets/crocodile_passive.png",
                          width: 200,
                          height: 200,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    // required to realise when we press / unpress
                    onTapDown: (details) {
                      game.p1press();
                      game.p2press();
                    },
                    onTapUp: (details) {
                      game.p2unpress();
                    },
                    child: Image.asset(
                      "assets/meat.jpeg",
                      width: 80,
                      height: 80,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(p1name, style: const TextStyle(fontSize: 25)),
                    gameOverButton(),
                    Text(p2name, style: const TextStyle(fontSize: 25)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ));
  }

  gameOverButton() {
    if ((game.p1score == 0 || game.p2score == 0) || (game.gameState == 1)) {
      return ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const StartScreen()));
          },
          child: const Text("Back to Menu"));
    } else {
      return const Text("");
    }
  }

  generatep1scores() {
    if (game.p1score < 4) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Opacity(
            opacity: game.p1score > 2 ? 1 : 0,
            child: Expanded(
              child: Image.asset("assets/heart.png"),
            ),
          ),
          Opacity(
            opacity: game.p1score > 1 ? 1 : 0,
            child: Expanded(
              child: Image.asset("assets/heart.png"),
            ),
          ),
          Opacity(
            opacity: game.p1score > 0 ? 1 : 0,
            child: Expanded(
              child: Image.asset("assets/heart.png"),
            ),
          )
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/heart.png"),
          Text(
            "x${game.p1score}",
            style: const TextStyle(fontSize: 25),
          )
        ],
      );
    }
  }

  generatep2scores() {
    if (game.p2score < 4) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Opacity(
            opacity: game.p2score > 0 ? 1 : 0,
            child: Expanded(
              child: Image.asset("assets/heart.png"),
            ),
          ),
          Opacity(
            opacity: game.p2score > 1 ? 1 : 0,
            child: Expanded(
              child: Image.asset("assets/heart.png"),
            ),
          ),
          Opacity(
            opacity: game.p2score > 2 ? 1 : 0,
            child: Expanded(
              child: Image.asset("assets/heart.png"),
            ),
          )
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/heart.png"),
          Text(
            "x${game.p2score}",
            style: const TextStyle(fontSize: 25),
          )
        ],
      );
    }
  }
}
