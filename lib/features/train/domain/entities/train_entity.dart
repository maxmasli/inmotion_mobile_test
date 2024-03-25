import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';

class TrainEntity {
  TrainEntity({
    required this.startTime,
    this.trainName = '',
  });

  // TODO create UUID

  final DateTime startTime;
  DateTime? endTime;

  String trainName;
  final List<PlayerEntity> players = [];

  void addPlayer(PlayerEntity player) {
    players.add(player);
  }
}
