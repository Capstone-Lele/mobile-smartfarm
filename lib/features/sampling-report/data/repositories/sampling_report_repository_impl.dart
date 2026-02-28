import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/data/datasources/sampling_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/data/models/sampling_report_model.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/entities/sampling_report.dart';
import 'package:budidaya_lele_mobile/features/sampling-report/domain/repositories/sampling_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class SamplingReportRepositoryImpl implements SamplingReportRepository {
  final SamplingReportDatasource datasource;

  SamplingReportRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<SamplingReport>>> getSamplingReports() async {
    final result = await datasource.getSamplingReports();

    return result.fold((failure) => Left(failure), (data) {
      final samplingReports = data
          .map((json) => SamplingReportModel.fromJson(json))
          .toList();
      return Right(samplingReports);
    });
  }

  @override
  Future<Either<Failure, SamplingReport>> getSamplingReport(String id) async {
    final result = await datasource.getSamplingReport(id);

    return result.fold((failure) => Left(failure), (data) {
      final samplingReport = SamplingReportModel.fromJson(data);
      return Right(samplingReport);
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createSamplingReport(
    String cycleId,
    String reportDate,
    int quantity,
    double averageWeight,
    XFile image,
  ) async {
    final result = await datasource.createSamplingReport(
      cycleId,
      reportDate,
      quantity,
      averageWeight,
      image,
    );

    return result.fold((failure) => Left(failure), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateSamplingReport(
    String id,
    String reportDate,
    int quantity,
    double averageWeight,
    XFile? image,
  ) async {
    final result = await datasource.updateSamplingReport(
      id,
      reportDate,
      quantity,
      averageWeight,
      image,
    );

    return result.fold((failure) => Left(failure), (data) => Right(data));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteSamplingReport(
    String id,
  ) async {
    final result = await datasource.deleteSamplingReport(id);

    return result.fold((failure) => Left(failure), (data) => Right(data));
  }
}
