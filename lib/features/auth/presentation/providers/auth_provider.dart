import 'package:budidaya_lele_mobile/common/services/fcm_service.dart';
import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_token_usecase.dart';
import '../../domain/usecases/unregister_token_usecase.dart';

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

final registerTokenUseCaseProvider = Provider<RegisterTokenUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return RegisterTokenUsecase(repository);
});

final unregisterTokenUseCaseProvider = Provider<UnregisterTokenUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return UnregisterTokenUsecase(repository);
});

// Notifier Provider
class LoginNotifier extends StateNotifier<AsyncValue<void>> {
  final LoginUseCase _loginUseCase;
  final RegisterTokenUsecase _registerTokenUseCase;
  final Ref _ref;

  LoginNotifier(this._loginUseCase, this._registerTokenUseCase, this._ref)
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
        
        // Register FCM token setelah login berhasil
        await _registerFcmToken();

        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<void> _registerFcmToken() async {
    try {
      // Paksa token segar saat login (workaround token "nyangkut"): hapus
      // token lama yang mungkin sudah mati di Firebase lalu buat token baru.
      final fcmToken = await FCMService.regenerateToken();
      if (fcmToken == null) return;
      print('FCM Token: $fcmToken');
      final deviceInfo = await FCMService.getDeviceInfo();
      await _registerTokenUseCase.execute(
        fcmToken,
        deviceInfo['name'] ?? 'Unknown Device',
        deviceInfo['type'] ?? 'android',
      );
    } catch (_) {}
  }
}

class LogoutNotifier extends StateNotifier<AsyncValue<void>> {
  final UnregisterTokenUsecase _unregisterTokenUseCase;
  final Ref _ref;

  LogoutNotifier(this._unregisterTokenUseCase, this._ref)
    : super(const AsyncValue.data(null));

  Future<bool> logout() async {
    state = const AsyncValue.loading();
    try {
      // Unregister FCM token sebelum clear session
      await _unregisterFcmToken();

      await AppSession.clearSession();
      _ref.invalidate(userProvider);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _unregisterFcmToken() async {
    try {
      final fcmToken = await FCMService.getToken();
      if (fcmToken == null) return;

      await _unregisterTokenUseCase.execute(fcmToken);
    } catch (_) {}
  }
}

// Provider Utama
final loginNotifierProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, AsyncValue<void>>((ref) {
      final loginUseCase = ref.read(loginUseCaseProvider);
      final registerTokenUseCase = ref.read(registerTokenUseCaseProvider);

      return LoginNotifier(loginUseCase, registerTokenUseCase, ref);
    });

final logoutNotifierProvider =
    StateNotifierProvider<LogoutNotifier, AsyncValue<void>>((ref) {
      final unregisterTokenUseCase = ref.read(unregisterTokenUseCaseProvider);
      return LogoutNotifier(unregisterTokenUseCase, ref);
    });
