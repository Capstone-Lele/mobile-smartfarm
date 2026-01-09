import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

// Provider untuk Datasource
final authDatasourceProvider = Provider((ref) => AuthDatasource());

// Provider untuk Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.watch(authDatasourceProvider);
  return AuthRepositoryImpl(datasource);
});

// Provider untuk UseCase
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

// StateNotifier untuk mengelola State UI
class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final LoginUseCase _loginUseCase;

  AuthNotifier(this._loginUseCase) : super(const AsyncValue.data(null));

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

        state = const AsyncValue.data(null);
        return true;
      },
    );
  }
}

// Provider Utama
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
      final loginUseCase = ref.watch(loginUseCaseProvider);
      return AuthNotifier(loginUseCase);
    });
