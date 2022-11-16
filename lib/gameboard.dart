import 'dart:async';

import 'dart:math';
import 'package:flutter/material.dart';
import "game.dart";

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

// these two store the icon size of the meat icons

// gameboard containing a number of items placed in a stack
class _GameBoardState extends State<GameBoard> {
  late Game game;

  @override
  void initState() {
    super.initState();

    game = Game();

    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        game.currentRotation += 2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          // top meat button
          left: 160,
          top: 30,
          child: GestureDetector(
            // required to realise when we press / unpress
            onTapDown: (details) {
              setState(() {
                game.p1press();
              });
            },
            onTapUp: (details) {
              setState(() {
                game.p1unpress();
              });
            },
            child: Transform.scale(
              scale: game.icon1Size,
              child: Image.asset(
                "assets/meat.jpeg",
                width: 80,
                height: 80,
              ),
            ),
          ),
        ),
        Positioned(
            // crocodile
            left: 100,
            top: 350,
            child: Transform.rotate(
              angle: game.currentRotation / 180 * pi,
              child: Image.asset(
                "assets/crocodile_passive.jpeg",
                width: 200,
                height: 200,
              ),
            )),
        Positioned(
          // bottom meat button
          left: 160,
          bottom: 30,
          child: GestureDetector(
            // required to realise when we press / unpress
            onTapDown: (details) {
              setState(() {
                game.p2press();
              });
            },
            onTapUp: (details) {
              setState(() {
                game.p2unpress();
              });
            },
            child: Transform.scale(
              scale: game.icon2Size,
              child: Image.asset(
                "assets/meat.jpeg",
                width: 80,
                height: 80,
              ),
            ),
          ),
        ),
        Positioned(
          // crocodile
          left: 0,
          top: 400,
          child: Transform.rotate(
            angle: 4.75,
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    game.startGame();
                  });
                },
                child: Text("todo")),
          ),
        ),
      ],
    ));
  }
}
