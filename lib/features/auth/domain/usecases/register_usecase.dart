import 'package:inmotion_mobile_test/core/domain/usecases/usecase.dart';
import 'package:inmotion_mobile_test/features/auth/domain/usecases/result.dart';

class RegisterUseCase
    implements UseCase<Result<String>, AuthInfoParams> {
  @override
  Future<Result<String>> call(AuthInfoParams params) {
    throw UnimplementedError();
  }
}

