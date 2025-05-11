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
