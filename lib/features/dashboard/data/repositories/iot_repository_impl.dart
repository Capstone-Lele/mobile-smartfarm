import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/dashboard/data/datasources/iot_datasource.dart';
import 'package:budidaya_lele_mobile/features/dashboard/data/models/chart_iots_model.dart';
import 'package:budidaya_lele_mobile/features/dashboard/data/models/iot_model.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/chart_iots.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/iot.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/repositories/iot_repository.dart';
import 'package:dartz/dartz.dart';

class IotRepositoryImpl implements IotRepository {
  final IotDatasource datasource;

  IotRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Iot>>> getIots() async {
    final result = await datasource.getIots();

    return result.fold((failure) => Left(failure), (data) {
      try {
        final iots = data.map((json) => IotModel.fromJson(json)).toList();
        return Right(iots);
      } catch (e) {
        return Left(InvalidInputFailure('Gagal mengkonversi data iot: $e'));
      }
    });
  }

  @override
  Future<Either<Failure, Iot>> getIot(String nodeId) async {
    final result = await datasource.getIot(nodeId);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final iot = IotModel.fromJson(data);
        return Right(iot);
      } catch (e) {
        return Left(InvalidInputFailure('Gagal mengkonversi data iot: $e'));
      }
    });
  }

  @override
  Future<Either<Failure, List<ChartIots>>> getChartIots(
    String nodeId,
    String startDate,
    String endDate,
  ) async {
    final result = await datasource.getChartIots(nodeId, startDate, endDate);

    return result.fold((failure) => Left(failure), (data) {
      try {
        final iots = data.map((json) => ChartIotsModel.fromJson(json)).toList();
        return Right(iots);
      } catch (e) {
        return Left(InvalidInputFailure('Gagal mengkonversi data chart iots: $e'));
      }
    });
  }
}
