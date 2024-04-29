import 'package:flutter/material.dart';

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.yellow,
      child: Center(
        child: Text("TopBarWidget"),
      ),
    );
  }
}
