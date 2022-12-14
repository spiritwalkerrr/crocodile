import 'dart:async';
import 'package:crocodile/main.dart';
import 'package:flutter/material.dart';
import "dart:math";

class Game extends ChangeNotifier {
  // basic variables
  bool p1pressed = false;
  bool p2pressed = false;
  int currentRotation = 0; // -90 p2 90 p1
  var crocAlignment = Alignment.center;
  bool aggressive = false;
  int p1score = p1lives;
  int p2score = p2lives;
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
    // used to generate random numbers for the game logic
    return min + Random().nextInt(max);
  }

  Game() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      // timer controls the game
      if (gameState == 2) {
        // if the game is during countdown
        resetCrocodile(); // resets the crocodile to the middle
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
        } else if (moveTimeout == 1) {
          // check if player didnt react in time
          resetRound();
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
      gameState = 2; // start countdown
    }
  }

  p1unpress() {
    p1pressed = false;
    if (!p2pressed && gameState == 4) {
      // check if previous round is over
      gameState = 1; // reset to pre-game
      alertText = "Place both fingers to start!";
      instructionText = "";
    } else if (gameState == 2) {
      // during countdown it resets the countdown
      resetRound();
      alertText = "Place both fingers to start!";
      instructionText = "";
    } else if (gameState == 3) {
      // check if we are during game
      // when a finger is removed during round
      if (!p1attacked) {
        // checks if that player was NOT attacked
        alertText = "$p1name wasn't attacked!";
        p1score--;
        if (p1score > 0) {
          instructionText = "Lift fingers to reset.";
        } else {
          instructionText = "Player 1 lost the game.";
        }
        resetRound();
        gameState = 4;
      } else if (p1attacked) {
        alertText = "$p1name evaded!";
        instructionText = "Lift fingers to reset.";
      }
    }
  }

  p2press() {
    p2pressed = true;
    if (p1pressed && gameState == 1) {
      // check if both buttons are pressed and if game is pre-countdown
      gameState = 2; // start countdown
      alertText = "Place both fingers to start!";
      instructionText = "";
    }
  }

  p2unpress() {
    p2pressed = false;
    if (!p1pressed && gameState == 4) {
      // check if previous round is over
      gameState = 1; // reset to pre-game
    } else if (gameState == 2) {
      // during countdown it resets the countdown
      resetRound();
      alertText = "Place both fingers to start!";
      instructionText = "";
    } else if (gameState == 3) {
      // check if we are during game
      // when a finger is removed during round
      if (!p2attacked) {
        // checks if that player was NOT attacked
        alertText = "$p2name wasn't attacked!";
        p2score--;
        if (p2score > 0) {
          instructionText = "Lift fingers to reset.";
        } else {
          instructionText = "Player 2 lost the game.";
        }
        resetRound();
        gameState = 4;
      } else if (p2attacked) {
        alertText = " $p2name evaded!";
        instructionText = "Lift fingers to reset.";
      }
    }
  }

  rotateCroc() {
    if (rotateTimeout == 0) {
      // see if its time to rotate
      rotateTimeout = randomNum(2, 5); // disable rotation for 1-2.5s
      if (currentRotation == 0) {
        currentRotation = 90;
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
      currentRotation = 90;
    } else {
      currentRotation = 0;
    }
  }

  resetCrocodile() {
    crocAlignment = Alignment.center;
    aggressive = false;
  }

  resetRound() {
    gameState = 4;
    moveTimeout = 0;
    gameCountdown = 6;
    p1attacked = false;
    p2attacked = false;
  }

  checkWin() {
    if (p1attacked && p1pressed) {
      // p1 attacked and still pressed
      alertText = "$p1name lost a finger!";
      p1score--;
    } else if (p2attacked && p2pressed) {
      alertText = "$p2name lost a finger!";
      p2score--;
    } else if (p1faked && p1pressed) {
      alertText = "$p1name didn't fall for it!";
    } else if (p2faked && p2pressed) {
      alertText = "$p2name didn't fall for it!";
    }
    if (p1score == 0) {
      alertText = "$p2name won the game!"; // to do: victory and reset screen
      instructionText = "";
    } else if (p2score == 0) {
      alertText = "$p1name won the game!"; // to do: victory and reset screen
      instructionText = "";
    } else {
      instructionText = "Lift fingers to reset.";
    }
  }
}
