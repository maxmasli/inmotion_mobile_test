import 'package:inmotion_mobile_test/di.dart' as di;
import 'package:inmotion_mobile_test/features/train/domain/repositories/train_repository.dart';

void main() {
  di.setup();
  final trainRepository = di.getIt<TrainRepository>();

}