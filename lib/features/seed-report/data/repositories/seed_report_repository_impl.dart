import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/seed-report/data/datasources/seed_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/seed-report/data/models/seed_report_model.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/entities/seed_report.dart';
import 'package:budidaya_lele_mobile/features/seed-report/domain/repositories/seed_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class SeedReportRepositoryImpl implements SeedReportRepository {
  final SeedReportDatasource datasource;

  SeedReportRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<SeedReport>>> getSeedReports() async {
    final result = await datasource.getSeedReports();

    return result.fold((failure) => Left(failure), (data) {
      final seedReports = data
          .map((json) => SeedReportModel.fromJson(json))
          .toList();
      return Right(seedReports);
    });
  }

  @override
  Future<Either<Failure, SeedReport>> getSeedReport(String id) async {
    final result = await datasource.getSeedReport(id);

    return result.fold((failure) => Left(failure), (data) {
      final seedReport = SeedReportModel.fromJson(data);
      return Right(seedReport);
    });
  }

  @override
  Future<Either<Failure, SeedReport>> createSeedReport(
    String poolId,
    String userId,
    String reportDate,
    int initialQuantity,
    int currentQuantity,
    double initialAverageWeight,
    XFile image,
  ) async {
    final result = await datasource.createSeedReport(
      poolId,
      userId,
      reportDate,
      initialQuantity,
      currentQuantity,
      initialAverageWeight,
      image,
    );

    return result.fold((failure) => Left(failure), (data) {
      final seedReport = SeedReportModel.fromJson(data);
      return Right(seedReport);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteSeedReport(
    String id,
  ) async {
    final result = await datasource.deleteSeedReport(id);

    return result.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }
}
