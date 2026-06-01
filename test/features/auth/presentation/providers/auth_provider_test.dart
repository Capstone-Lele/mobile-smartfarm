import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/auth/domain/entities/auth.dart';
import 'package:budidaya_lele_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:budidaya_lele_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:budidaya_lele_mobile/features/auth/domain/usecases/register_token_usecase.dart';
import 'package:budidaya_lele_mobile/features/auth/domain/usecases/unregister_token_usecase.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:budidaya_lele_mobile/features/user/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/user/domain/repositories/user_repository.dart';
import 'package:budidaya_lele_mobile/features/user/domain/usecases/get_user_info_usecase.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Fake implementations
class FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, Auth>> login(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> registerToken(
    String fcmToken,
    String deviceName,
    String deviceType,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> unregisterToken(
    String fcmToken,
  ) {
    throw UnimplementedError();
  }
}

class FakeLoginUseCase implements LoginUseCase {
  @override
  final AuthRepository repository = FakeAuthRepository();

  late Future<Either<Failure, Auth>> Function(String, String)? _executeCallback;

  void setupExecute(
    Future<Either<Failure, Auth>> Function(String, String) callback,
  ) {
    _executeCallback = callback;
  }

  @override
  Future<Either<Failure, Auth>> execute(String email, String password) {
    if (_executeCallback != null) {
      return _executeCallback!(email, password);
    }
    throw UnimplementedError();
  }
}

class FakeRegisterTokenUsecase implements RegisterTokenUsecase {
  @override
  final AuthRepository repository = FakeAuthRepository();

  late Future<Either<Failure, Map<String, dynamic>>> Function(
    String,
    String,
    String,
  )?
  _executeCallback;

  void setupExecute(
    Future<Either<Failure, Map<String, dynamic>>> Function(
      String,
      String,
      String,
    )
    callback,
  ) {
    _executeCallback = callback;
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> execute(
    String fcmToken,
    String deviceName,
    String deviceType,
  ) {
    if (_executeCallback != null) {
      return _executeCallback!(fcmToken, deviceName, deviceType);
    }
    throw UnimplementedError();
  }
}

class FakeUnregisterTokenUsecase implements UnregisterTokenUsecase {
  @override
  final AuthRepository repository = FakeAuthRepository();

  late Future<Either<Failure, Map<String, dynamic>>> Function(String)?
  _executeCallback;

  void setupExecute(
    Future<Either<Failure, Map<String, dynamic>>> Function(String) callback,
  ) {
    _executeCallback = callback;
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> execute(String fcmToken) {
    if (_executeCallback != null) {
      return _executeCallback!(fcmToken);
    }
    throw UnimplementedError();
  }
}

class FakeUserRepository implements UserRepository {
  @override
  Future<Either<Failure, Map<String, dynamic>>> changePassword(
    String oldPassword,
    String newPassword,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> changeProfile(
    String name,
    dynamic image,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> getUserInfo() {
    throw UnimplementedError();
  }
}

class FakeGetUserInfoUsecase implements GetUserInfoUsecase {
  @override
  final UserRepository repository = FakeUserRepository();

  @override
  Future<Either<Failure, User>> execute() async {
    return Right(
      User(
        id: 'test-id',
        name: 'Test User',
        email: 'test@example.com',
        role: 'staff',
        image: '',
      ),
    );
  }
}

void main() {
  late FakeLoginUseCase fakeLoginUseCase;
  late FakeRegisterTokenUsecase fakeRegisterTokenUsecase;

  setUp(() {
    fakeLoginUseCase = FakeLoginUseCase();
    fakeRegisterTokenUsecase = FakeRegisterTokenUsecase();
  });

  group('LoginNotifier', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    final testAuth = Auth(
      expiresAt: '2024-12-31',
      token: 'token_xyz',
      type: 'Bearer',
    );

    test(
      'login should return true and complete successfully on valid credentials',
      () async {
        // Arrange
        fakeLoginUseCase.setupExecute((email, password) async {
          return Right(testAuth);
        });

        fakeRegisterTokenUsecase.setupExecute((token, device, type) async {
          return Right(<String, dynamic>{});
        });

        final container = ProviderContainer(
          overrides: [
            loginUseCaseProvider.overrideWithValue(fakeLoginUseCase),
            registerTokenUseCaseProvider.overrideWithValue(
              fakeRegisterTokenUsecase,
            ),
            getUserInfoUseCaseProvider.overrideWithValue(
              FakeGetUserInfoUsecase(),
            ),
          ],
        );

        final notifier = container.read(loginNotifierProvider.notifier);

        // Act
        final result = await notifier.login(testEmail, testPassword);

        // Assert
        expect(result, true);
        expect(notifier.state.hasValue, true);
      },
    );

    test(
      'loginNotifierProvider should be initialized with AsyncData(null)',
      () {
        // Arrange
        final container = ProviderContainer(
          overrides: [
            loginUseCaseProvider.overrideWithValue(fakeLoginUseCase),
            registerTokenUseCaseProvider.overrideWithValue(
              fakeRegisterTokenUsecase,
            ),
          ],
        );

        // Act
        final state = container.read(loginNotifierProvider);

        // Assert
        expect(state.hasValue, true);
      },
    );

    test(
      'login should return false and emit error state when authentication fails',
      () async {
        // Arrange
        final failure = FetchFailure('Invalid credentials');
        fakeLoginUseCase.setupExecute((email, password) async {
          return Left(failure);
        });

        final container = ProviderContainer(
          overrides: [
            loginUseCaseProvider.overrideWithValue(fakeLoginUseCase),
            registerTokenUseCaseProvider.overrideWithValue(
              fakeRegisterTokenUsecase,
            ),
            getUserInfoUseCaseProvider.overrideWithValue(
              FakeGetUserInfoUsecase(),
            ),
          ],
        );

        final notifier = container.read(loginNotifierProvider.notifier);

        // Act
        final result = await notifier.login(testEmail, testPassword);

        // Assert
        expect(result, false);
        expect(notifier.state.hasError, true);
        expect(notifier.state.error, 'Invalid credentials');
      },
    );
  });
}
