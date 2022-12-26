import 'package:crocodile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crocodile/gameboard.dart';

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
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(208, 219, 219, 1),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text(
                        "How many lives?",
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: TextFormField(
                          onChanged: (value) => game.p1name = value,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: "P1 Name",
                              labelStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: TextFormField(
                          onChanged: (value) => game.p2name = value,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              labelText: "P2 Name",
                              labelStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 2, color: Colors.black)),
                  onPressed: () {
                    setLives(count);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GameBoard()));
                  },
                  child: const Text("Start Game",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)))
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
    game.p1score = value;
    game.p2score = value;
  }

  int count = 3;
}
