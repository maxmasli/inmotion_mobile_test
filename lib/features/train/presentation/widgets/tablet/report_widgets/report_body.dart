import 'package:flutter/material.dart';

class ReportBody extends StatelessWidget {
  const ReportBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.purple,
      child: Center(
        child: Text("Tablet report body"),
      ),
    );
  }
}
