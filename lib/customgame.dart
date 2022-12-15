import 'package:crocodile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crocodile/gameboard.dart';
import "game.dart";

class CustomGame extends StatefulWidget {
  const CustomGame({super.key});

  @override
  State<CustomGame> createState() => _CustomGameState();
}

// gameboard containing a number of items placed in a stack
class _CustomGameState extends State<CustomGame> {
  final _formKey = GlobalKey<FormState>();

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
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "How many Lives?",
                    style: TextStyle(fontSize: 30),
                  ),
                  const Spacer(),
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(
                      Icons.remove_circle_rounded,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          addLife(false);
                        },
                      );
                    },
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      count.toString(),
                      style: const TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    iconSize: 30,
                    icon: const Icon(
                      Icons.add_circle_rounded,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          addLife(true);
                        },
                      );
                    },
                  ),
                ],
              ),
              const Spacer(),
              TextFormField(
                onChanged: (value) => p1name = value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "P1 Name",
                ),
              ),
              const Spacer(),
              TextFormField(
                onChanged: (value) => p2name = value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "P2 Name",
                ),
              ),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    setLives(count);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GameBoard()));
                  },
                  child: const Text("Start Game"))
            ],
          ),
        ),
      ),
    );
  }

  addLife(bool add) {
    if (add && count < 10) {
      count++;
    } else if (!add && count > 1) {
      count--;
    }
  }

  setLives(value) {
    p1lives = value;
    p2lives = value;
  }

  int count = 3;
}
