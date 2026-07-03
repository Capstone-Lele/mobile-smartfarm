import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/data/datasources/move_pool_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/data/models/move_pool_report_model.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/entities/move_pool_report.dart';
import 'package:budidaya_lele_mobile/features/move-pool-report/domain/repositories/move_pool_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class MovePoolReportRepositoryImpl implements MovePoolReportRepository {
  final MovePoolReportDatasource datasource;

  MovePoolReportRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<MovePoolReport>>> getMovePoolReports(
    String poolId,
  ) async {
    final result = await datasource.getMovePoolReports(poolId);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final movePoolReports = data
            .map((json) => MovePoolReportModel.fromJson(json))
            .toList();
        return Right(movePoolReports);
      } catch (e) {
        return Left(
          InvalidInputFailure(
            "Gagal mengkonversi data laporan pindah kolam: $e",
          ),
        );
      }
    });
  }

  @override
  Future<Either<Failure, MovePoolReport>> getMovePoolReport(String id) async {
    final result = await datasource.getMovePoolReport(id);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final movePoolReport = MovePoolReportModel.fromJson(data);
        return Right(movePoolReport);
      } catch (e) {
        return Left(
          InvalidInputFailure(
            "Gagal mengkonversi data laporan pindah kolam: $e",
          ),
        );
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createMovePoolReport(
    String poolId,
    String originCycleId,
    String? destinationCycleId,
    String reportDate,
    int quantity,
    XFile image,
    String? endedAt,
  ) async {
    final result = await datasource.createMovePoolReport(
      poolId,
      originCycleId,
      destinationCycleId,
      reportDate,
      quantity,
      image,
      endedAt,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }
}
