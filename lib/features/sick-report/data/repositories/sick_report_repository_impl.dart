import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sick-report/data/datasources/sick_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/sick-report/data/models/sick_report_detail_model.dart';
import 'package:budidaya_lele_mobile/features/sick-report/data/models/sick_report_model.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/entities/sick_report.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/entities/sick_report_detail.dart';
import 'package:budidaya_lele_mobile/features/sick-report/domain/repositories/sick_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class SickReportRepositoryImpl implements SickReportRepository {
  final SickReportDatasource datasource;

  SickReportRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<SickReport>>> getSickReports(
    String poolId,
  ) async {
    final result = await datasource.getSickReports(poolId);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final sickReports = data
            .map((json) => SickReportModel.fromJson(json))
            .toList();
        return Right(sickReports);
      } catch (e) {
        return Left(
          InvalidInputFailure("Gagal mengkonversi data laporan sakit: $e"),
        );
      }
    });
  }

  @override
  Future<Either<Failure, SickReportDetail>> getSickReport(String id) async {
    final result = await datasource.getSickReport(id);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final sickReport = SickReportDetailModel.fromJson(data);
        return Right(sickReport);
      } catch (e) {
        return Left(
          InvalidInputFailure("Gagal mengkonversi data laporan sakit: $e"),
        );
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createSickReport(
    String originCycleId,
    String destinationCycleId,
    String reportDate,
    int quantity,
    XFile image,
  ) async {
    final result = await datasource.createSickReport(
      originCycleId,
      destinationCycleId,
      reportDate,
      quantity,
      image,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteSickReport(
    String id,
  ) async {
    final result = await datasource.deleteSickReport(id);

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }
}
