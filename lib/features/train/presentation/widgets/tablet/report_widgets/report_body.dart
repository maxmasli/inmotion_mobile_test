import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';
import 'package:inmotion_mobile_test/features/train/presentation/provider/train_model.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/player_info/player_info_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/players_info/players_info_widget.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/train_calendar.dart';
import 'package:inmotion_mobile_test/features/train/presentation/widgets/tablet/report_widgets/trains_info/trains_info_widget.dart';
import 'package:provider/provider.dart';

class ReportBody extends StatefulWidget {
  const ReportBody({super.key});

  @override
  State<ReportBody> createState() => _ReportBodyState();
}

class _ReportBodyState extends State<ReportBody> {
  List<DateTime?> range = [];
  TrainEntity? selectedTrain;
  PlayerEntity? selectedPlayer;

  @override
  Widget build(BuildContext context) {
    final model = context.read<TrainModel>();
    if (selectedTrain != null && selectedPlayer != null) {
      return PlayerInfoWidget(
        onBackPressed: () {
          setState(() {
            selectedPlayer = null;
          });
        },
        train: selectedTrain!,
        player: selectedPlayer!,
      );
    }
    if (selectedTrain != null) {
      return PlayersInfoWidget(
        range: range,
        train: selectedTrain!,
        onRangeChanged: (range) {
          setState(() {
            this.range = range;
          });
        },
        onBackPressed: () {
          setState(() {
            selectedTrain = null;
          });
        },
        onPlayerSelected: (player) {
          setState(() {
            selectedPlayer = player;
          });
        },
      );
    } else {
      return TrainsInfoWidget(
        range: range,
        onRangeChanged: (range) {
          setState(() {
            this.range = range;
          });
        },
        onTrainSelect: (train) async {
          await model.loadPlayersToTrain(train);
          setState(() {
            selectedTrain = train;
          });
        },
      );
    }
  }
}
