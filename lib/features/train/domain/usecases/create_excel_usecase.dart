import 'package:inmotion_mobile_test/core/domain/usecases/usecase.dart';
import 'package:inmotion_mobile_test/core/utils/excel/excel_generator.dart';
import 'package:inmotion_mobile_test/features/train/domain/repositories/players_repository.dart';

class CreateExcelUseCase implements UseCase<String, TrainParams> {

  final PlayersRepository playersRepository;

  const CreateExcelUseCase({
    required this.playersRepository,
  });

  @override
  Future<String> call(TrainParams params) async {
    final train = params.train;
    if (train.players.isEmpty) { // Игроки еще не загружены
      final players = await playersRepository.getPlayers(train.playersKey!);
      train.addAllPlayers(players);
    }
    print('Train players length: ${train.players.length}');
    final path = await ExcelGenerator().createExcel(train);
    return path;
  }
}
