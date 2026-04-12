import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:budidaya_lele_mobile/features/user/data/datasources/user_datasource.dart';
import 'package:budidaya_lele_mobile/features/user/data/repositories/user_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/user/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/user/domain/repositories/user_repository.dart';
import 'package:budidaya_lele_mobile/features/user/domain/usecases/change_password_usecase.dart';
import 'package:budidaya_lele_mobile/features/user/domain/usecases/change_profile_usecase.dart';
import 'package:budidaya_lele_mobile/features/user/domain/usecases/get_user_info_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

// Provider Datasource
final userDatasourceProvider = Provider((ref) => UserDatasource());

// Provider Repository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final datasource = ref.read(userDatasourceProvider);
  return UserRepositoryImpl(datasource);
});

// Provider UseCase
final getUserInfoUseCaseProvider = Provider<GetUserInfoUsecase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUserInfoUsecase(repository);
});

final changePasswordUseCaseProvider = Provider<ChangePasswordUsecase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return ChangePasswordUsecase(repository);
});

final changeProfileUseCaseProvider = Provider<ChangeProfileUsecase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return ChangeProfileUsecase(repository);
});

// Notifier Provider
class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final GetUserInfoUsecase _getUserInfoUsecase;
  final Ref _ref;

  UserNotifier(this._getUserInfoUsecase, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> getUserInfo() async {
    if (!AppSession.isTokenValid()) {
      state = AsyncValue.error('Sesi berakhir', StackTrace.current);
      return;
    }
    state = const AsyncValue.loading();

    final result = await _getUserInfoUsecase.execute();

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (user) {
        _ref.read(userProvider.notifier).state = user;
        state = AsyncValue.data(user);
      },
    );
  }
}

class UserMutationNotifier extends StateNotifier<AsyncValue<void>> {
  final ChangePasswordUsecase _changePasswordUsecase;
  final ChangeProfileUsecase _changeProfileUsecase;

  UserMutationNotifier(this._changePasswordUsecase, this._changeProfileUsecase)
    : super(const AsyncValue.data(null));

  // Change Password
  Future<void> changePassword(String oldPassword, String newPassword) async {
    state = const AsyncValue.loading();
    final result = await _changePasswordUsecase.execute(
      oldPassword,
      newPassword,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah password',
          StackTrace.current,
        );
      },
      (user) {
        state = AsyncValue.data(null);
      },
    );
  }

  // Change Profile
  Future<void> changeProfile(String name, XFile? image) async {
    state = const AsyncValue.loading();
    final result = await _changeProfileUsecase.execute(name, image);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal mengubah profile',
          StackTrace.current,
        );
      },
      (user) {
        state = AsyncValue.data(null);
      },
    );
  }
}

// StateProvider Global
final userProvider = StateProvider<User?>((ref) => null);

// Provider Utama
final userInfoNotifierProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
      final getUserInfoUsecase = ref.read(getUserInfoUseCaseProvider);
      return UserNotifier(getUserInfoUsecase, ref);
    });

// User Mutation Notifier Provider
final userMutationNotifierProvider =
    StateNotifierProvider<UserMutationNotifier, AsyncValue<void>>((ref) {
      final changePasswordUsecase = ref.read(changePasswordUseCaseProvider);
      final changeProfileUsecase = ref.read(changeProfileUseCaseProvider);

      return UserMutationNotifier(changePasswordUsecase, changeProfileUsecase);
    });
