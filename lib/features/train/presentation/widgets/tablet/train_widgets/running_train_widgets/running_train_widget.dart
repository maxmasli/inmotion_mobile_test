import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';

class RunningTrainWidget extends StatefulWidget {
  const RunningTrainWidget({super.key});

  @override
  State<RunningTrainWidget> createState() => _RunningTrainWidgetState();
}

class _RunningTrainWidgetState extends State<RunningTrainWidget> {

  PlayerEntity? _selectedPlayer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text("zones"),
              flex: 2,
            ),
            Expanded(
              child: Text("train edit"),
            ),
          ],
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text("List"),
              ),
              Expanded(
                child: Text("info"),
              )
            ],
          ),
        )
      ],
    );
  }
}
