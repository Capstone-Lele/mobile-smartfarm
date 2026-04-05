import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/data/datasources/vitamin_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/data/models/vitamin_report_model.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/entities/vitamin_report.dart';
import 'package:budidaya_lele_mobile/features/vitamin-report/domain/repositories/vitamin_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class VitaminReportRepositoryImpl implements VitaminReportRepository {
  final VitaminReportDatasource datasource;

  VitaminReportRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<VitaminReport>>> getVitaminReports(
    String poolId,
  ) async {
    final result = await datasource.getVitaminReports(poolId);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final vitaminReports = data
            .map((json) => VitaminReportModel.fromJson(json))
            .toList();
        return Right(vitaminReports);
      } catch (e) {
        return Left(
          InvalidInputFailure('Gagal mengkonversi data laporan vitamin: $e'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, VitaminReport>> getVitaminReport(String id) async {
    final result = await datasource.getVitaminReport(id);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final vitaminReport = VitaminReportModel.fromJson(data);
        return Right(vitaminReport);
      } catch (e) {
        return Left(
          InvalidInputFailure('Gagal mengkonversi data laporan vitamin: $e'),
        );
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createVitaminReport(
    String cycleId,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile image,
  ) async {
    final result = await datasource.createVitaminReport(
      cycleId,
      inventoryId,
      reportDate,
      quantity,
      image,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateVitaminReport(
    String id,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile? image,
  ) async {
    final result = await datasource.updateVitaminReport(
      id,
      inventoryId,
      reportDate,
      quantity,
      image,
    );

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteVitaminReport(
    String id,
  ) async {
    final result = await datasource.deleteVitaminReport(id);

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }
}
