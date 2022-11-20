import 'dart:async';
import 'package:flutter/material.dart';
import "dart:math";

class Game extends ChangeNotifier {
  // basic variables
  bool p1pressed = false;
  bool p2pressed = false;
  int currentRotation = -90; // -90 p2 90 p1
  int currentPosition = 0; // 0 == center, higher is p1 lower is p2
  bool aggressive = false;
  int p1score = 3;
  int p2score = 3;
  bool p1attacked = false;
  bool p2attacked = false;
  bool p1faked = false;
  bool p2faked = false;
  // timeout that blocks a new move from being generated whilst one is active
  int moveTimeout = 0;
  int rotateTimeout = 0;
  // variables needed for deciding the next move
  int playerOdds = 3;
  int actionOdds = 3;
  int nextTarget = 1; // 1 = p1, 2 = p2
  int nextAction = 1; // 1 = attack, 2 = fake
// text variable for the explanations
  String alertText = "Place both fingers to start!";
  String instructionText = "";
// essential variables about the game start
  int gameState =
      1; // 1 = before round, 2 = during countdown, 3 = during round, 4 = end of round
  int gameCountdown = 6;

  int randomNum(int min, int max) {
    return min + Random().nextInt(max);
  }

  Game() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (gameState == 2) {
        resetCrocodile();
        instructionText = "";
        if (gameCountdown > 4) {
          alertText = "3";
        } else if (gameCountdown > 2) {
          alertText = "2";
        } else if (gameCountdown > 0) {
          alertText = "1";
        } else {
          alertText = "Watch your Fingers!";
          gameState = 3;
        }
        gameCountdown--;
      }

      if (gameState == 3) {
        if (moveTimeout == 0) {
          // see if a move is active, if its 0 its not, need to generate a new one
          generateAction();
          moveTimeout = 3 + randomNum(4, 10); // make a move in between 5-8s
        } else if (moveTimeout > 3) {
          rotateCroc();
        } else if (moveTimeout == 3) {
          // during the second you have time to react
          if (nextAction == 1) {
            // check if croc is attacking
            if (nextTarget == 1) {
              p1attacked = true; // set attacked player variable
            } else if (nextTarget == 2) {
              p2attacked = true; // set attacked player variable
            }
          } else if (nextAction == 2) {
            // check if croc is faking
            if (nextTarget == 1) {
              p1faked = true; // set faked player variable
            } else if (nextTarget == 2) {
              p2faked = true; // set faked player variable
            }
          }
          animateAttack();
        } else if (moveTimeout == 1) {
          if (p1attacked && p1pressed) {
            alertText = " Player 1 lost a finger!";
            instructionText = "Lift fingers to reset.";
            p1score--;
            resetRound();
          } else if (p2attacked && p2pressed) {
            alertText = " Player 2 lost a finger!";
            instructionText = "Lift fingers to reset.";
            p2score--;
            resetRound();
          } else if (p1faked && p1pressed) {
            alertText = " Player 1 didn't fall for it!";
            instructionText = "Lift fingers to reset.";
            resetRound();
          } else if (p2faked && p2pressed) {
            alertText = " Player 2 didn't fall for it!";
            instructionText = "Lift fingers to reset.";
            resetRound();
          }
          p1attacked = false;
          p2attacked = false;
          p1faked = false;
          p2faked = false;
        }
        if (moveTimeout > 1) {
          moveTimeout--;
        }
        // MAYBE else: RESET ROUND NEED HERE
      }

      notifyListeners();
    });
  }

  p1press() {
    p1pressed = true;
    if (p2pressed && gameState == 1) {
      // check if both buttons are pressed and if game is pre-countdown
      gameState = 2;
    }
  }

  p1unpress() {
    p1pressed = false;
    if (!p2pressed && gameState == 4) {
      alertText = "Place both fingers to start!";
      instructionText = "";
      gameState = 1;
    }
    if (gameState == 2) {
      // during countdown it resets the countdown
      resetRound();
    }
    if (gameState == 3) {
      // when a finger is removed during round
      if (!p1attacked) {
        // checks if that player was NOT attacked
        alertText = " Player 1 wasn't attacked!";
        instructionText = "Lift fingers to reset.";
        p1score--;
        resetRound();
        gameState = 4;
      } else if (p1attacked) {
        alertText = " Player 1 evaded!";
        instructionText = "Lift fingers to reset.";
      }
    }
  }

  p2press() {
    p2pressed = true;
    if (p1pressed && gameState == 1) {
      // check if both buttons are pressed and if game is pre-countdown
      gameState = 2;
    }
  }

  p2unpress() {
    p2pressed = false;
    if (!p1pressed && gameState == 4) {
      alertText = "Place both fingers to start!";
      instructionText = "";
      gameState = 1;
    }
    if (gameState == 2) {
      // during countdown it resets the countdown
      resetRound();
    }
    if (gameState == 3) {
      // when a finger is removed during round
      if (!p2attacked) {
        // checks if that player was NOT attacked
        alertText = "Player 2 wasn't attacked!";
        instructionText = "Lift fingers to reset.";
        p2score--;
        resetRound();
        gameState = 4;
      } else if (p2attacked) {
        alertText = " Player 2 evaded!";
        instructionText = "Lift fingers to reset.";
      }
    }
  }

  rotateCroc() {
    if (rotateTimeout == 0) {
      // see if its time to rotate
      // 50% chance to rotate
      rotateTimeout = randomNum(2, 5); // disable rotation for 1-2.5s
      if (currentRotation == -90) {
        currentRotation = 90;
      } else {
        currentRotation = -90;
      }
    } else {
      rotateTimeout--;
    }
  }

  generateAction() {
    // decide which player to attack
    int playerNum = randomNum(0, 7);
    if (playerNum > playerOdds) {
      // attack player 1
      nextTarget = 1;
      playerOdds++; // decrease chance of consecutive attacks
    } else {
      // attack player 2
      nextTarget = 2;
      playerOdds--; // decrease chance of consecutive attacks
    }
    // decide which type of attack
    int actionNum = randomNum(0, 7);
    if (actionNum > actionOdds) {
      nextAction = 1;
      actionOdds++;
    } else {
      // attack player 2
      nextAction = 2;
      actionOdds--; // decrease chance of consecutive attacks
    }
  }

  animateAttack() {
    if (nextTarget == 1) {
      currentRotation = 90;
      currentPosition += 150;
      if (nextAction == 1) {
        aggressive = true;
      }
    } else {
      currentRotation = -90;
      currentPosition -= 150;
      if (nextAction == 1) {
        aggressive = true;
      }
    }
  }

  resetCrocodile() {
    currentPosition = 0;
    aggressive = false;
  }

  resetRound() {
    gameState = 4;
    moveTimeout = 0;
    gameCountdown = 6;
    p1attacked = false;
    p2attacked = false;
    if (p1score == 0) {
      alertText = "Player 2 won the game!"; // to do: victory and reset screen
    } else if (p2score == 0) {
      alertText = "Player 1 won the game!"; // to do: victory and reset screen
    }
  }
}
