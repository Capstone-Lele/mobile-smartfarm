import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:budidaya_lele_mobile/features/auth/domain/entities/user.dart';
import 'package:budidaya_lele_mobile/features/auth/domain/usecases/get_user_info_usecase.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Provider UseCase
final getUserInfoUseCaseProvider = Provider<GetUserInfoUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return GetUserInfoUsecase(repository);
});

// Notifier Provider
class UserNotifier extends StateNotifier<AsyncValue<void>> {
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
      final getUserInfoUsecase = ref.read(getUserInfoUseCaseProvider);
      return UserNotifier(getUserInfoUsecase, ref);
    });
