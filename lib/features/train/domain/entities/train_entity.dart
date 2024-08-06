import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/split_entity.dart';
import 'package:uuid/uuid.dart';

class TrainEntity {
  TrainEntity({
    required this.startTime,
    this.uuid,
    this.playersKey,
    this.endTime,
    this.trainName = '',
    this.trainDescription = '',
  }) {
    uuid ??= const Uuid().v4();
    playersKey ??= const Uuid().v4();
  }

  String? uuid;

  String? playersKey;

  final DateTime startTime;

  DateTime? endTime;

  String trainName;

  String trainDescription;

  final List<PlayerEntity> players = [];

  final List<SplitEntity> exerciseSplits = [];

  void addPlayer(PlayerEntity player) {
    players.add(player);
  }

  void addAllPlayers(Iterable<PlayerEntity> playersList) {
    players.addAll(playersList);
  }

  void addSplits(Iterable<SplitEntity> splits) {
    exerciseSplits.clear();
    exerciseSplits.addAll(splits
        .where((s) => s.correctFragments(endTime!.difference(startTime))));
  }

  @override
  String toString() {
    return "TrainEntity: $uuid, startTime: $startTime";
  }
}
