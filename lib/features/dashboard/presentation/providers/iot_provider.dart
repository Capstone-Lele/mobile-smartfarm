// Provider Datasource
import 'package:budidaya_lele_mobile/features/dashboard/data/datasources/iot_datasource.dart';
import 'package:budidaya_lele_mobile/features/dashboard/data/repositories/iot_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/iot.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/repositories/iot_repository.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/usecases/get_iot_usecase.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/usecases/get_iots_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final iotDatasourceProvider = Provider((ref) => IotDatasource());

// Provider Repository
final iotRepositoryProvider = Provider<IotRepository>((ref) {
  final datasource = ref.read(iotDatasourceProvider);
  return IotRepositoryImpl(datasource);
});

// Provider Usecase
final getIotsUseCaseProvider = Provider<GetIotsUsecase>((ref) {
  final repository = ref.read(iotRepositoryProvider);
  return GetIotsUsecase(repository);
});

final getIotUseCaseProvider = Provider<GetIotUsecase>((ref) {
  final repository = ref.read(iotRepositoryProvider);
  return GetIotUsecase(repository);
});

class IotListNotifier extends StateNotifier<AsyncValue<List<Iot>>> {
  final GetIotsUsecase _getIotsUsecase;

  IotListNotifier(this._getIotsUsecase) : super(const AsyncValue.data([]));

  Future<void> getIots() async {
    state = const AsyncValue.loading();
    final result = await _getIotsUsecase.execute();

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (iots) {
        state = AsyncValue.data(iots);
      },
    );
  }
}

class IotDetailNotifier extends StateNotifier<AsyncValue<Iot?>> {
  final GetIotUsecase _getIotUsecase;

  IotDetailNotifier(this._getIotUsecase) : super(const AsyncValue.data(null));

  Future<void> getIot(String nodeId) async {
    state = const AsyncValue.loading();
    final result = await _getIotUsecase.execute(nodeId);

    result.fold(
      (failure) {
        state = AsyncValue.error(
          failure.message ?? 'Terjadi kesalahan',
          StackTrace.current,
        );
      },
      (iot) {
        state = AsyncValue.data(iot);
      },
    );
  }
}

// provider Utama
// Iot List Notifier Provider
final iotListNotifierProvider =
    StateNotifierProvider<IotListNotifier, AsyncValue<List<Iot>>>((ref) {
      final getIotsUsecase = ref.read(getIotsUseCaseProvider);

      return IotListNotifier(getIotsUsecase);
    });

// Iot Detail Notifier Provider
final iotDetailNotifierProvider =
    StateNotifierProvider<IotDetailNotifier, AsyncValue<Iot?>>((ref) {
      final getIotUsecase = ref.read(getIotUseCaseProvider);
      return IotDetailNotifier(getIotUsecase);
    });
