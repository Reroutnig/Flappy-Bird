import 'dart:async';
import 'package:flappybirdie/bird.dart';
import 'package:flappybirdie/pipes.dart';
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
  bool hitsPipe1 = (birdTop < pipe1GapTop || birdBottom > pipe1GapBottom) &&
      (pipe1Left < 0 && pipe1Right > 0);

  // Collision with pipe 2
  bool hitsPipe2 = (birdTop < pipe2GapTop || birdBottom > pipe2GapBottom) &&
      (pipe2Left < 0 && pipe2Right > 0);

  // Check if bird hits ground or sky
  bool hitsGround = birdBottom > 1;
  //bool hitsSky = birdTop < -1;

  return hitsPipe1 || hitsPipe2 || hitsGround;
}
