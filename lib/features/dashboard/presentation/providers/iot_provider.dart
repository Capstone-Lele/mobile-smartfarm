import 'dart:async';
import 'package:budidaya_lele_mobile/features/dashboard/data/datasources/iot_datasource.dart';
import 'package:budidaya_lele_mobile/features/dashboard/data/models/iot_model.dart';
import 'package:budidaya_lele_mobile/features/dashboard/data/repositories/iot_repository_impl.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/chart_iots.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/iot.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/repositories/iot_repository.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/usecases/get_chart_iots_usecase.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/usecases/get_iot_usecase.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/usecases/get_iots_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Provider Datasource
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

final getChartIotsUseCaseProvider = Provider<GetChartIotsUsecase>((ref) {
  final repository = ref.read(iotRepositoryProvider);
  return GetChartIotsUsecase(repository);
});

class IotListNotifier extends StateNotifier<AsyncValue<List<Iot>>> {
  final GetIotsUsecase _getIotsUsecase;
  Timer? _fallbackTimer;

  IotListNotifier(this._getIotsUsecase) : super(const AsyncValue.data([]));

  Future<void> getIots({bool showLoading = true}) async {
    if (showLoading) {
      state = const AsyncValue.loading();
    }
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

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    super.dispose();
  }

  /// Set loading dan jadwalkan fallback ke list kosong setelah 5 detik
  /// jika tidak ada event socket yang masuk.
  void setLoading() {
    _fallbackTimer?.cancel();
    state = const AsyncValue.loading();
    _fallbackTimer = Timer(const Duration(seconds: 5), () {
      if (state.isLoading) {
        state = const AsyncValue.data([]);
      }
    });
  }

  /// Inserts or replaces (by nodeId) a single pool's realtime reading.
  void upsertSocketData(Map<String, dynamic> json) {
    _fallbackTimer?.cancel();
    final incoming = IotModel.fromSocket(json);
    final current = state.value ?? <Iot>[];
    final updated = [...current];
    final index = updated.indexWhere((e) => e.nodeId == incoming.nodeId);
    if (index >= 0) {
      updated[index] = incoming;
    } else {
      updated.add(incoming);
    }
    state = AsyncValue.data(updated);
  }
}

class IotDetailNotifier extends StateNotifier<AsyncValue<Iot?>> {
  final GetIotUsecase _getIotUsecase;
  Timer? _fallbackTimer;

  IotDetailNotifier(this._getIotUsecase) : super(const AsyncValue.data(null));

  Future<void> getIot(String nodeId, {bool showLoading = true}) async {
    if (showLoading) {
      state = const AsyncValue.loading();
    }
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

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    super.dispose();
  }

  /// Set loading dan jadwalkan fallback ke nilai 0 setelah 5 detik
  /// jika tidak ada event socket yang masuk.
  void setLoading(int nodeId) {
    _fallbackTimer?.cancel();
    state = const AsyncValue.loading();
    _fallbackTimer = Timer(const Duration(seconds: 5), () {
      if (state.isLoading) {
        state = AsyncValue.data(
          IotModel(nodeId: nodeId, ph: 0.0, temp: 0.0, receivedAt: ''),
        );
      }
    });
  }

  /// Replaces the current pool's reading with a realtime `pool-data` payload.
  void applySocketData(Map<String, dynamic> json) {
    _fallbackTimer?.cancel();
    state = AsyncValue.data(IotModel.fromSocket(json));
  }
}

class ChartIotsNotifier extends StateNotifier<AsyncValue<List<ChartIots>>> {
  final GetChartIotsUsecase _getChartIotsUsecase;

  ChartIotsNotifier(this._getChartIotsUsecase)
    : super(const AsyncValue.data([]));

  Future<void> getChartIots(
    String nodeId,
    String startDate,
    String endDate,
  ) async {
    state = const AsyncValue.loading();

    final result = await _getChartIotsUsecase.execute(
      nodeId,
      startDate,
      endDate,
    );

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

// Chart Iots Notifier Provider
final chartIotsNotifierProvider =
    StateNotifierProvider<ChartIotsNotifier, AsyncValue<List<ChartIots>>>((
      ref,
    ) {
      final getChartIotsUsecase = ref.read(getChartIotsUseCaseProvider);

      return ChartIotsNotifier(getChartIotsUsecase);
    });
