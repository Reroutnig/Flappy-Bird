import 'dart:async';
import 'bird.dart';
import 'pipes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double intHeight = birdYaxis;
  bool gameStart = false;
  static double pipeXone = 1;
  double pipeXtwo = pipeXone + 1.5;
  int score = 0, highScore = 0;

  void jump() {
    setState(() {
      time = 0;
      intHeight = birdYaxis;
    });
  }

  void startGame() {
    gameStart = true;
    Timer.periodic(Duration(milliseconds: 41), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = intHeight - height;
      });
      setState(() {
        if (pipeXone < -2) {
          pipeXone += 3.5;
          score += 1;
        } else {
          pipeXone -= 0.05;
        }
      });
      setState(() {
        if (pipeXtwo < -2) {
          pipeXtwo += 3.5;
          score += 1;
        } else {
          pipeXtwo -= 0.05;
        }
      });
      if (birdYaxis > 1 || _checkCollision()) {
        timer.cancel();
        gameStart = false;
        _gameOverDialog();
      }
    });
  }

  bool _checkCollision() {
    // Bird's position
    double birdTop = birdYaxis - 0.05; // 100 pixels normalized to 0.05
    double birdBottom = birdYaxis + 0.05;

    // Pipe 1 bounds
    double pipe1Left = pipeXone - 0.1; // 100 pixels normalized to 0.1
    double pipe1Right = pipeXone + 0.1;
    double pipe1GapTop = -0.5; // Adjust based on visual gap
    double pipe1GapBottom = 0.5; // Adjust based on visual gap

    // Pipe 2 bounds
    double pipe2Left = pipeXtwo - 0.1;
    double pipe2Right = pipeXtwo + 0.1;
    double pipe2GapTop = -0.25; // Adjust based on visual gap
    double pipe2GapBottom = 0.65; // Adjust based on visual gap

    // Collision with pipe 1
    bool hitsPipe1 =
        (birdTop < pipe1GapTop || birdBottom > pipe1GapBottom) &&
        (pipe1Left < 0 && pipe1Right > 0);

    // Collision with pipe 2
    bool hitsPipe2 =
        (birdTop < pipe2GapTop || birdBottom > pipe2GapBottom) &&
        (pipe2Left < 0 && pipe2Right > 0);

    // Check if bird hits ground or sky
    bool hitsGround = birdBottom > 1;
    //bool hitsSky = birdTop < -1;

    return hitsPipe1 || hitsPipe2 || hitsGround;
  }

  void _gameOverDialog() {
    if (score > highScore) {
      highScore = score; // Update high score
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Center(
            child: Text("GAME OVER", style: TextStyle(color: Colors.white)),
          ),
          content: Text("Score: $score", style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              child: Text("PLAY AGAIN", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame(); // Reset the game
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      birdYaxis = 0;
      time = 0;
      intHeight = birdYaxis;
      pipeXone = 1;
      pipeXtwo = pipeXone + 1.5;
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameStart) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: MyBird(),
                  ),
                  Container(
                    alignment: Alignment(0, -0.2),
                    child:
                        gameStart
                            ? Text(" ")
                            : Text(
                              "T A P  T O  P L A Y",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(pipeXone, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyPipes(size: 200.0),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(pipeXone, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyPipes(size: 200.0),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(pipeXtwo, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyPipes(size: 150.0),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(pipeXtwo, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyPipes(size: 250.0),
                  ),
                ],
              ),
            ),
            Container(height: 15, color: Colors.green),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Score:",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "$score",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Best:",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "$highScore",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
