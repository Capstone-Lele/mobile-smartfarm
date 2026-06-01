import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/user/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/user/domain/repositories/user_repository.dart';
import 'package:budidaya_lele_mobile/features/user/domain/usecases/change_password_usecase.dart';
import 'package:budidaya_lele_mobile/features/user/domain/usecases/change_profile_usecase.dart';
import 'package:budidaya_lele_mobile/features/user/domain/usecases/get_user_info_usecase.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

class FakeUserRepository implements UserRepository {
  Future<Either<Failure, User>> Function()? _getUserCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String, String)? _changePasswordCallback;
  Future<Either<Failure, Map<String, dynamic>>> Function(String, XFile?)? _changeProfileCallback;

  void setupGetUser(Future<Either<Failure, User>> Function() callback) => _getUserCallback = callback;
  void setupChangePassword(Future<Either<Failure, Map<String, dynamic>>> Function(String, String) callback) => _changePasswordCallback = callback;
  void setupChangeProfile(Future<Either<Failure, Map<String, dynamic>>> Function(String, XFile?) callback) => _changeProfileCallback = callback;

  @override
  Future<Either<Failure, User>> getUserInfo() {
    if (_getUserCallback != null) return _getUserCallback!();
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> changePassword(String oldPassword, String newPassword) {
    if (_changePasswordCallback != null) return _changePasswordCallback!(oldPassword, newPassword);
    return Future.value(Left(FetchFailure('Not setup')));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> changeProfile(String name, XFile? image) {
    if (_changeProfileCallback != null) return _changeProfileCallback!(name, image);
    return Future.value(Left(FetchFailure('Not setup')));
  }
}

User _makeUser() => User(
  id: 'user-1',
  name: 'John Doe',
  email: 'john@example.com',
  role: 'pic',
  image: 'https://example.com/avatar.jpg',
);

void main() {
  late FakeUserRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeUserRepository();
  });

  group('UserNotifier', () {
    test('getUserInfo should return data on success when token is valid', () async {
      // Arrange
      fakeRepository.setupGetUser(() async => Right<Failure, User>(_makeUser()));

      // Act - langsung panggil use case tanpa guard AppSession
      final usecase = GetUserInfoUsecase(fakeRepository);
      final result = await usecase.execute();

      // Assert
      expect(result.isRight(), true);
      final user = result.getOrElse(() => throw Exception());
      expect(user.id, 'user-1');
      expect(user.name, 'John Doe');
      expect(user.role, 'pic');
    });

    test('userInfoNotifierProvider should be initialized with AsyncData(null)', () {
      final container = ProviderContainer(
        overrides: [
          getUserInfoUseCaseProvider.overrideWithValue(
            GetUserInfoUsecase(fakeRepository),
          ),
        ],
      );

      final state = container.read(userInfoNotifierProvider);

      expect(state.hasValue, true);
      expect(state.value, null);
    });

    test('getUserInfo should emit error when token is not valid (AppSession not init)', () async {
      // Arrange - AppSession tidak di-init, sehingga token null -> isTokenValid() = false
      fakeRepository.setupGetUser(() async => Right<Failure, User>(_makeUser()));

      final container = ProviderContainer(
        overrides: [
          getUserInfoUseCaseProvider.overrideWithValue(
            GetUserInfoUsecase(fakeRepository),
          ),
        ],
      );

      // Act
      await container.read(userInfoNotifierProvider.notifier).getUserInfo();

      // Assert - harus error karena token tidak valid
      expect(container.read(userInfoNotifierProvider), isA<AsyncError>());
      final error = (container.read(userInfoNotifierProvider) as AsyncError).error;
      expect(error.toString(), contains('Sesi berakhir'));
    });
  });

  group('UserMutationNotifier', () {
    late UserMutationNotifier mutationNotifier;

    setUp(() {
      mutationNotifier = UserMutationNotifier(
        ChangePasswordUsecase(fakeRepository),
        ChangeProfileUsecase(fakeRepository),
      );
    });

    test('changePassword should return data on success', () async {
      // Arrange
      fakeRepository.setupChangePassword(
        (old, newPass) async => Right<Failure, Map<String, dynamic>>({'message': 'Password berhasil diubah'}),
      );

      // Act
      await mutationNotifier.changePassword('oldpass123', 'newpass456');

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('userMutationNotifierProvider should be initialized with AsyncData(null)', () {
      final container = ProviderContainer(
        overrides: [
          changePasswordUseCaseProvider.overrideWithValue(ChangePasswordUsecase(fakeRepository)),
          changeProfileUseCaseProvider.overrideWithValue(ChangeProfileUsecase(fakeRepository)),
        ],
      );

      final state = container.read(userMutationNotifierProvider);

      expect(state.hasValue, true);
      expect(state is AsyncData, true);
    });

    test('changePassword should emit error state on network failure', () async {
      // Arrange
      fakeRepository.setupChangePassword(
        (old, newPass) async => Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')),
      );

      // Act
      await mutationNotifier.changePassword('oldpass123', 'newpass456');

      // Assert
      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });

    test('changeProfile should return data on success', () async {
      // Arrange
      fakeRepository.setupChangeProfile(
        (name, image) async => Right<Failure, Map<String, dynamic>>({'message': 'Profile berhasil diubah'}),
      );

      // Act
      await mutationNotifier.changeProfile('Jane Doe', null);

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('changeProfile should return data on success with image', () async {
      // Arrange
      fakeRepository.setupChangeProfile(
        (name, image) async => Right<Failure, Map<String, dynamic>>({'message': 'Profile berhasil diubah'}),
      );

      // Act
      await mutationNotifier.changeProfile('Jane Doe', XFile('avatar.jpg'));

      // Assert
      expect(mutationNotifier.state, isA<AsyncData<void>>());
    });

    test('changeProfile should emit error state on network failure', () async {
      // Arrange
      fakeRepository.setupChangeProfile(
        (name, image) async => Left<Failure, Map<String, dynamic>>(FetchFailure('Network error')),
      );

      // Act
      await mutationNotifier.changeProfile('Jane Doe', null);

      // Assert
      expect(mutationNotifier.state, isA<AsyncError>());
      final error = (mutationNotifier.state as AsyncError).error;
      expect(error.toString(), contains('Network error'));
    });
  });
}
