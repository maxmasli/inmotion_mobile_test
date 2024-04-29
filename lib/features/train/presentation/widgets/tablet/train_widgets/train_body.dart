import 'package:flutter/material.dart';

class TrainBody extends StatelessWidget {
  const TrainBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.green,
      child: Center(
        child: Text("Tablet train body"),
      ),
    );
  }
}
