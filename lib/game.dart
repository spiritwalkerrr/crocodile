import 'dart:async';
import 'package:flutter/material.dart';
import "dart:math";

class Game extends ChangeNotifier {
  // basic variables
  String p1name = "Player 1";
  String p2name = "Player 2";
  bool p1pressed = false;
  bool p2pressed = false;
  double currentRotation = 0; // -90 p2 90 p1
  var crocAlignment = Alignment.center;
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
      1; // 1 = before round, 2 = during countdown, 3 = during round, 4 = end of round, 5 = game over
  int gameCountdown = 6;

  int randomNum(int min, int max) {
    // used to generate random numbers for the game logic
    return min + Random().nextInt(max);
  }

  Game() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      // timer controls the game
      if (gameState == 2) {
        // if the game is during countdown
        instructionText = "";
        if (gameCountdown > 4) {
          // 4 = 2s left
          alertText = "3";
        } else if (gameCountdown > 2) {
          // 2 = 1s left
          alertText = "2";
        } else if (gameCountdown > 0) {
          alertText = "1";
        } else {
          alertText = "Watch your Fingers!";
          gameState = 3; // game round has started
        }
        gameCountdown--; // countdown continues if we are in this phase
      }

      if (gameState == 3) {
        // if the game is during round
        if (moveTimeout == 0) {
          // see if a move is active, if its 0 its not, need to generate a new one
          generateAction(); // generates a move for the croc (attack/fake)
          moveTimeout = 3 + randomNum(4, 10); // make a move in between 5-8s
        } else if (moveTimeout > 5) {
          rotateCroc();
        } else if (moveTimeout == 4) {
          correctRotation();
        } else if (moveTimeout == 3) {
          // during the last second you have time to react
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
          animateAttack(); // animate attack
        }
        if (moveTimeout == 1 && nextAction == 2) {
          checkWin(
              "timer"); // checking 1s after fake, if fingers are let go before you loose, even if croc has finished moving
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
      gameState = 2; // start countdown
    }
    notifyListeners();
  }

  p1unpress() {
    p1pressed = false;
    if (gameState == 4 && !p2pressed) {
      resetRound();
    } else {
      checkWin("unpress");
    }
    notifyListeners();
  }

  p2press() {
    p2pressed = true;
    if (p1pressed && gameState == 1) {
      // check if both buttons are pressed and if game is pre-countdown
      gameState = 2; // start countdown
      alertText = "Place both fingers to start!";
      instructionText = "";
    }
    notifyListeners();
  }

  p2unpress() {
    p2pressed = false;
    if (gameState == 4 && !p1pressed) {
      resetRound();
    } else {
      checkWin("unpress");
    }
    notifyListeners();
  }

  rotateCroc() {
    if (rotateTimeout == 0) {
      // see if its time to rotate
      rotateTimeout = randomNum(2, 5); // disable rotation for 1-2.5s
      if (currentRotation == 0) {
        currentRotation = pi;
      } else {
        currentRotation = 0;
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
      // attack
      nextAction = 1;
      actionOdds++;
    } else {
      // fake
      nextAction = 2;
      actionOdds--; // decrease chance of consecutive attacks
    }
  }

  animateAttack() {
    if (nextTarget == 1) {
      crocAlignment = Alignment.centerLeft;
      if (nextAction == 1) {
        aggressive = true;
      }
    } else {
      crocAlignment = Alignment.centerRight;
      if (nextAction == 1) {
        aggressive = true;
      }
    }
  }

  correctRotation() {
    if (nextTarget == 1) {
      currentRotation = pi;
    } else {
      currentRotation = 0;
    }
  }

  resetCrocodile() {
    crocAlignment = Alignment.center;
    aggressive = false;
  }

  resetRound() {
    alertText = "Place both fingers to start!";
    instructionText = "";
    gameState = 1;
    moveTimeout = 0;
    gameCountdown = 6;
    p1attacked = false;
    p2attacked = false;
    p1faked = false;
    p2faked = false;
    resetCrocodile(); // resets the crocodile to the middle
  }

  checkWin(reason) {
    // we check this if someone lifted a finger or if time is up
    // reason == "unpress" if finger liften
    // reason == "timer" if time ran out
    if (gameState == 2 && reason == "unpress") {
      // checking for reason isnt necessariy, for better understanding only
      // during countdown it resets the countdown
      resetRound(); // reset to pre-game
    } else if (gameState == 3 && reason == "timer") {
      // check if time ran out, checking if we are mid-round also required (dont ask me why lol)
      gameState = 4; // round is now over
      if ((p1pressed && p2pressed) && p1faked || p2faked) {
        // both fingers down and fake attack
        if (p1faked) {
          // p1 was fake attacked
          alertText = "$p1name didn't fall for it";
        } else if (p2faked) {
          // p2 was fake attacked
          alertText = "$p2name didn't fall for it";
        }
      }
    } else if (gameState == 3 && reason == "attacked") {
      gameState = 4;
      if (p1pressed && p2pressed) {
        // both fingers down but one player was attacked
        if (p1attacked) {
          // p1 was attacked
          alertText = "$p1name lost a finger";
          p1score--;
        } else if (p2attacked) {
          // p2 was attacked
          alertText = "$p2name lost a finger";
          p2score--;
        }
      }
    } else if (gameState == 3 && reason == "unpress") {
      // check if someone lifted finger and if it was during the game round
      gameState = 4;
      if (!p1pressed && p1attacked) {
        // if p1 released because they were attacked
        alertText = "$p1name evaded the crocodile";
      } else if (!p2pressed && p2attacked) {
        // if p2 released because they were attacked
        alertText = "$p2name evaded the crocodile";
      } else if (!p1pressed && !p1attacked) {
        // if p1 released but wasn't attacked
        alertText = "$p1name wasn't attacked";
        p1score--;
      } else if (!p2pressed && !p2attacked) {
        // if p2 released but wasn't attacked
        alertText = "$p2name wasn't attacked";
        p2score--;
      }
    }
    if (p1score != 0 && p2score != 0 && gameState != 1) {
      // after scores are adjusted if needed, we need to check if the game is not over yet
      instructionText = "Lift both fingers to reset";
    } else if (p1score == 0) {
      gameState = 5;
      alertText = "$p2name won the game!";
    } else if (p2score == 0) {
      gameState = 5;
      alertText = "$p1name won the game!";
    }
    notifyListeners();
  }
}
