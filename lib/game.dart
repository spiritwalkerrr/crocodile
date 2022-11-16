import 'package:crocodile/gameboard.dart';

class Game {
  bool p1pressed = false;
  bool p2pressed = false;

  int currentRotation = 4;

  double icon1Size = 1;
  double icon2Size = 1;

  p1press() {
    currentRotation = 4;
    icon1Size = 1.1;
    p1pressed = true;
  }

  p1unpress() {
    currentRotation = 1;
    icon1Size = 1;
    p1pressed = false;
  }

  p2press() {
    currentRotation = 2;
    icon2Size = 1.1;
    p2pressed = true;
  }

  p2unpress() {
    currentRotation = 3;
    icon2Size = 1;
    p2pressed = false;
  }

  startGame() {}
}
