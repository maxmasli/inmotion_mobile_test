import 'package:inmotion_mobile_test/features/train/domain/entities/player_entity.dart';
import 'package:inmotion_mobile_test/features/train/domain/entities/train_entity.dart';

abstract interface class UseCase<R, P extends Params> {
  Future<R> call(P params);
}

abstract class Params {

}

class EmptyParams extends Params {

}

class TrainParams extends Params {
  final TrainEntity train;

  TrainParams(this.train);
}

class TrainsListParams extends Params {
  final List<TrainEntity> trains;

  TrainsListParams(this.trains);
}

class BooleanParams extends Params {
  final bool value;

  BooleanParams(this.value);
}

class PlayersParams extends Params {
  final PlayerEntity player;

  PlayersParams(this.player);
}

class StringParams extends Params {
  final String value;

  StringParams(this.value);
}

class AuthInfoParams extends Params {
  final String login;
  final String password;
  final String device;

  AuthInfoParams({
    required this.login,
    required this.password,
    required this.device,
  });
}

class TrainPlayerListParams extends Params {
  final TrainEntity train;
  final List<PlayerEntity> players;

  TrainPlayerListParams(this.train, this.players);
}

class TrainPlayerParams extends Params {
  final TrainEntity train;
  final PlayerEntity player;

  TrainPlayerParams(this.train, this.player);
}