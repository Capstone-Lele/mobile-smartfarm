import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/data/datasources/mortality_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/data/models/mortality_report_model.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/entities/mortality_report.dart';
import 'package:budidaya_lele_mobile/features/mortality-report/domain/repositories/mortality_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class MortalityReportRepositoryImpl implements MortalityReportRepository {
  final MortalityReportDatasource datasource;

  MortalityReportRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<MortalityReport>>> getMortalityReports() async {
    final result = await datasource.getMortalityReports();

    return result.fold((failure) => Left(failure), (data) {
      final mortalityRepots = data
          .map((json) => MortalityReportModel.fromJson(json))
          .toList();
      return Right(mortalityRepots);
    });
  }

  @override
  Future<Either<Failure, MortalityReport>> getMortalityReport(String id) async {
    final result = await datasource.getMortalityReport(id);

    return result.fold((failure) => Left(failure), (data) {
      final mortalityReport = MortalityReportModel.fromJson(data);
      return Right(mortalityReport);
    });
  }

  @override
  Future<Either<Failure, MortalityReport>> createMortalityReport(
    String cycleId,
    String userId,
    String reportDate,
    int quantity,
    XFile image,
  ) async {
    final result = await datasource.createMortalityReport(
      cycleId,
      userId,
      reportDate,
      quantity,
      image,
    );

    return result.fold((failure) => Left(failure), (data) {
      final mortalityReport = MortalityReportModel.fromJson(data);
      return Right(mortalityReport);
    });
  }

  @override
  Future<Either<Failure, MortalityReport>> updateMortalityReport(
    String id,
    String reportDate,
    int quantity,
    XFile? image,
  ) async {
    final result = await datasource.updateMortalityReport(
      id,
      reportDate,
      quantity,
      image,
    );

    return result.fold((failure) => Left(failure), (data) {
      final mortalityReport = MortalityReportModel.fromJson(data);
      return Right(mortalityReport);
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
