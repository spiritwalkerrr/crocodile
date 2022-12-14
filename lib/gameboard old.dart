// ignore: file_names
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "game.dart";

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
      body: AnimatedBuilder(
        animation: game,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                // top meat button
                left: 160,
                top: 30,
                child: GestureDetector(
                  // required to realise when we press / unpress
                  onTapDown: (details) {
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
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 1000),
                // crocodile
                left: 100,
                top: 350 // + game.currentPosition.toDouble(),
                ,
                child: Transform.rotate(
                  angle: game.currentRotation / 180 * pi,
                  child: Image.asset(
                    game.aggressive == true
                        ? "assets/crocodile_angry.png"
                        : "assets/crocodile_passive.png",
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
              Positioned(
                // bottom meat button
                left: 160,
                bottom: 30,
                child: GestureDetector(
                  // required to realise when we press / unpress
                  onTapDown: (details) {
                    game.p1press();
                    game.p2press(); // todo: remove this
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
              ),
              Positioned(
                left: -270,
                top: 410,
                child: Transform.rotate(
                  angle: -90 / 180 * pi,
                  child: SizedBox(
                      height: 30,
                      width: 600,
                      child: Text(
                        game.alertText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      )),
                ),
              ),
              Positioned(
                left: -230,
                top: 410,
                child: Transform.rotate(
                  angle: -90 / 180 * pi,
                  child: SizedBox(
                    height: 30,
                    width: 600,
                    child: Text(
                      game.instructionText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 100,
                child: Transform.rotate(
                  angle: -90 / 180 * pi,
                  child: SizedBox(
                    height: 30,
                    width: 90,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: game.p2score > 2 ? 1 : 0,
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
                          opacity: game.p2score > 0 ? 1 : 0,
                          child: Expanded(
                            child: Image.asset("assets/heart.png"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 720,
                child: Transform.rotate(
                  angle: -90 / 180 * pi,
                  child: SizedBox(
                    height: 30,
                    width: 90,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: game.p1score > 0 ? 1 : 0,
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
                          opacity: game.p1score > 2 ? 1 : 0,
                          child: Expanded(
                            child: Image.asset("assets/heart.png"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
