import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:uuid/uuid.dart';

class TrainEntity {
  TrainEntity({
    required this.startTime,
    this.uuid,
    this.playersKey,
    this.endTime,
    this.trainName = '',
  }) {
    uuid ??= const Uuid().v4();
    playersKey ??= const Uuid().v4();
  }

  String? uuid;
  String? playersKey;

  final DateTime startTime;
  DateTime? endTime;

  String trainName;
  final List<PlayerEntity> players = [];

  void addPlayer(PlayerEntity player) {
    players.add(player);
  }

  void addAllPlayers(Iterable<PlayerEntity> playersList) {
    players.addAll(playersList);
  }

  @override
  String toString() {
    return "TrainEntity: $trainName, startTime: $startTime";
  }
}
