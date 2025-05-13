import 'package:flutter/material.dart';

class MyPipes extends StatelessWidget {
  final size;
  MyPipes({this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: BoxDecoration(
          color: Colors.greenAccent,
          border: Border.all(width: 10, color: Colors.greenAccent.shade700),
          borderRadius: BorderRadius.circular(15)),
    );
  }
}
