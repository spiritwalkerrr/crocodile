import 'package:crocodile/startscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "main.dart";

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

// gameboard containing a number of items placed in a stack
class _GameBoardState extends State<GameBoard> {
  @override
  void initState() {
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
                        height: 40,
                        width: 90,
                        child: generateScores(game.p1score),
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
                        child: generateScores(game.p2score),
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
                        child: Transform.scale(
                          scale: game.p1pressed ? 1.3 : 1,
                          child: Image.asset(
                            "assets/meat.jpeg",
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      Expanded(
                        child: AnimatedAlign(
                          alignment: game.crocAlignment,
                          duration: const Duration(milliseconds: 700),
                          onEnd: () => {
                            if (game.nextAction ==
                                1) // we want to check for successful attack when animation is over, not when a fake happens. if a fake happens players should remain on the button a bit more, hence we check using the timer.
                              {game.checkWin("attacked")}
                          },
                          curve: Curves.easeInExpo,
                          child: AnimatedContainer(
                            transformAlignment: Alignment.center,
                            transform: Matrix4.rotationY(game.currentRotation),
                            duration: const Duration(milliseconds: 500),
                            child: Image.asset(
                              game.aggressive
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
                          game.p2press();
                        },
                        onTapUp: (details) {
                          game.p2unpress();
                        },
                        child: Transform.scale(
                          scale: game.p2pressed ? 1.3 : 1,
                          child: Image.asset(
                            "assets/meat.jpeg",
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(game.p1name, style: const TextStyle(fontSize: 25)),
                        gameOverButton(),
                        Text(game.p2name, style: const TextStyle(fontSize: 25)),
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
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: const BorderSide(width: 2, color: Colors.black)),
        onPressed: () {
          game.resetRound();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const StartScreen()));
        },
        child: const Text("Back to Menu",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      );
    } else {
      return const Text("", style: TextStyle(color: Colors.black));
    }
  }

  generateScores(int score) {
    if (score < 4) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Opacity(
              opacity: score > 2 ? 1 : 0,
              child: Image.asset("assets/heart.jpeg"),
            ),
          ),
          Expanded(
            child: Opacity(
              opacity: score > 1 ? 1 : 0,
              child: Image.asset("assets/heart.jpeg"),
            ),
          ),
          Expanded(
            child: Opacity(
              opacity: score > 0 ? 1 : 0,
              child: Image.asset("assets/heart.jpeg"),
            ),
          )
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/heart.jpeg"),
          Text(
            "x$score",
            style: const TextStyle(fontSize: 25),
          )
        ],
      );
    }
  }
}
