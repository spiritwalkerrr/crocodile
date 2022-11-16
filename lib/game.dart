import 'dart:async';

import 'package:crocodile/gameboard.dart';
import 'package:flutter/material.dart';

class Game extends ChangeNotifier {
  bool p1pressed = false;
  bool p2pressed = false;

  int currentRotation = 4;

  double icon1Size = 1;
  double icon2Size = 1;

  Game() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      currentRotation += 2;

      notifyListeners();
    });
  }

  p1press() {
    currentRotation = 4;
    icon1Size = 1.1;
    p1pressed = true;

    notifyListeners();
  }

  p1unpress() {
    currentRotation = 1;
    icon1Size = 1;
    p1pressed = false;

    notifyListeners();
  }

  p2press() {
    currentRotation = 2;
    icon2Size = 1.1;
    p2pressed = true;

    notifyListeners();
  }

  p2unpress() {
    currentRotation = 3;
    icon2Size = 1;
    p2pressed = false;

    notifyListeners();
  }

  startGame() {}
}
