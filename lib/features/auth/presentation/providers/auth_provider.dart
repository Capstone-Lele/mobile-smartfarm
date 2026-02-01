import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:budidaya_lele_mobile/features/auth/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

// Provider Datasource
final authDatasourceProvider = Provider((ref) => AuthDatasource());

// Provider Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.read(authDatasourceProvider);
  return AuthRepositoryImpl(datasource);
});

// Provider UseCase
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUseCase(repository);
});

// Notifier Provider
class LoginNotifier extends StateNotifier<AsyncValue<void>> {
  final LoginUseCase _loginUseCase;
  final Ref _ref;

  LoginNotifier(this._loginUseCase, this._ref)
    : super(const AsyncValue.data(null));

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await _loginUseCase.execute(email, password);

    return result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
        return false;
      },
      (user) async {
        // Simpan token ke session storage
        await AppSession.setBearerToken(user.token);
        await _ref.read(userInfoNotifierProvider.notifier).getUserInfo();
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }
}

class LogoutNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  LogoutNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<bool> logout() async {
    state = const AsyncValue.loading();
    try {
      await AppSession.clearSession();
      _ref.invalidate(userProvider);
      return true;
    } catch (e) {
      return false;
    }
  }
}

// Provider Utama
final loginNotifierProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, AsyncValue<void>>((ref) {
      final loginUseCase = ref.read(loginUseCaseProvider);

      return LoginNotifier(loginUseCase, ref);
    });

final logoutNotifierProvider =
    StateNotifierProvider<LogoutNotifier, AsyncValue<void>>((ref) {
      return LogoutNotifier(ref);
    });
