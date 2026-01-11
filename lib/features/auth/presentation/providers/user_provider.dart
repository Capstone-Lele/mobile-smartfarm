import 'package:budidaya_lele_mobile/features/auth/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/auth/domain/usecases/get_user_info_usecase.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Provider untuk UseCase
final getUserInfoUseCaseProvider = Provider<GetUserInfoUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetUserInfoUsecase(repository);
});

class UserNotifier extends StateNotifier<AsyncValue<void>> {
  final GetUserInfoUsecase _useCase;
  final Ref _ref;

  UserNotifier(this._useCase, this._ref) : super(const AsyncValue.data(null));

  Future<void> fetchUserInfo() async {
    state = const AsyncValue.loading();

    final result = await _useCase.execute();

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Gagal memuat profil',
          StackTrace.current,
        );
      },
      (user) {
        _ref.read(userProvider.notifier).state = user;
        state = const AsyncValue.data(null);
      },
    );
  }
}

// StateProvider Global
final userProvider = StateProvider<User?>((ref) => null);

// Provider Utama
final userInfoNotifierProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<void>>((ref) {
      final useCase = ref.watch(getUserInfoUseCaseProvider);
      return UserNotifier(useCase, ref);
    });
