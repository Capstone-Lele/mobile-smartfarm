import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/data/datasources/mortality_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/data/models/mortality_report_detail_model.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/data/models/mortality_report_model.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report_detail.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/repositories/mortality_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class MortalityReportRepositoryImpl implements MortalityReportRepository {
  final MortalityReportDatasource datasource;

  MortalityReportRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<MortalityReport>>> getMortalityReports(
    String poolId,
  ) async {
    final result = await datasource.getMortalityReports(poolId);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final mortalityReports = data
            .map((json) => MortalityReportModel.fromJson(json))
            .toList();
        return Right(mortalityReports);
      } catch (e) {
        return Left(
          InvalidInputFailure("Gagal mengkonversi data laporan kematian: $e"),
        );
      }
    });
  }

  @override
  Future<Either<Failure, MortalityReportDetail>> getMortalityReport(
    String id,
  ) async {
    final result = await datasource.getMortalityReport(id);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final mortalityReport = MortalityReportDetailModel.fromJson(data);
        return Right(mortalityReport);
      } catch (e) {
        return Left(
          InvalidInputFailure("Gagal mengkonversi data laporan kematian: $e"),
        );
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createMortalityReport(
    String cycleId,
    String userId,
    String reportDate,
    int quantity,
    XFile image,
    String notes,
  ) async {
    final result = await datasource.createMortalityReport(
      cycleId,
      userId,
      reportDate,
      quantity,
      image,
      notes,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateMortalityReport(
    String id,
    String reportDate,
    int quantity,
    XFile? image,
    String notes,
  ) async {
    final result = await datasource.updateMortalityReport(
      id,
      reportDate,
      quantity,
      image,
      notes,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteMortalityReport(
    String id,
  ) async {
    final result = await datasource.deleteMortalityReport(id);

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }
}
