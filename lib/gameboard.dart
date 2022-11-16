import 'package:flutter/material.dart';
import "game.dart";

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

// these two store the icon size of the meat icons
double icon1Size = 1;
double icon2Size = 1;
bool gameStarted = false;
int counter = 0;

// gameboard containing a number of items placed in a stack
class _GameBoardState extends State<GameBoard> {
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
                p1press();
              });
            },
            onTapUp: (details) {
              setState(() {
                p1unpress();
              });
            },
            child: Transform.scale(
              scale: icon1Size,
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
              angle: pi / currentRotation,
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
                p2press();
              });
            },
            onTapUp: (details) {
              setState(() {
                p2unpress();
              });
            },
            child: Transform.scale(
              scale: icon2Size,
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
                    startGame();
                  });
                },
                child: Text(counter.toString())),
          ),
        ),
      ],
    ));
  }
}
