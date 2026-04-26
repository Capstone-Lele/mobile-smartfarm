import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/iot.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/chart_iots.dart';
import 'package:dartz/dartz.dart';

abstract class IotRepository {
  Future<Either<Failure, List<Iot>>> getIots();
  Future<Either<Failure, Iot>> getIot(String nodeId);
  Future<Either<Failure, List<ChartIots>>> getChartIots(
    String nodeId,
    String startDate,
    String endDate,
  );
}
