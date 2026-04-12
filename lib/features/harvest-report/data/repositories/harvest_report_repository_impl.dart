import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/data/datasources/harvest_report_datasource.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/data/models/harvest_report_detail_model.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/data/models/harvest_report_model.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/entities/harvest_report.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/entities/harvest_report_detail.dart';
import 'package:budidaya_lele_mobile/features/harvest-report/domain/repositories/harvest_report_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class HarvestReportRepositoryImpl implements HarvestReportRepository {
  final HarvestReportDatasource datasource;

  HarvestReportRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<HarvestReport>>> getHarvestReports(
    String poolId,
  ) async {
    final result = await datasource.getHarvestReports(poolId);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final harvestReports = data
            .map((json) => HarvestReportModel.fromJson(json))
            .toList();
        return Right(harvestReports);
      } catch (e) {
        return Left(InvalidInputFailure("Gagal mengkonversi data laporan panen: $e"));
      }
    });
  }

  @override
  Future<Either<Failure, HarvestReportDetail>> getHarvestReport(String id) async {
    final result = await datasource.getHarvestReport(id);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final harvestReport = HarvestReportDetailModel.fromJson(data);
        return Right(harvestReport);
      } catch (e) {
        return Left(InvalidInputFailure("Gagal mengkonversi data laporan panen: $e"));
      }
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createHarvestReport(
    String cycleId,
    String reportDate,
    int amount,
    XFile image,
  ) async {
    final result = await datasource.createHarvestReport(
      cycleId,
      reportDate,
      amount,
      image,
    );

    return result.fold((failure) => Left(failure), (data) => Right(data));
  }
}
