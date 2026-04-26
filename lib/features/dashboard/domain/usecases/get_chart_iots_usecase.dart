import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/chart_iots.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/repositories/iot_repository.dart';
import 'package:dartz/dartz.dart';

class GetChartIotsUsecase {
  final IotRepository repository;

  GetChartIotsUsecase(this.repository);

  Future<Either<Failure, List<ChartIots>>> execute(
    String nodeId,
    String startDate,
    String endDate,
  ) {
    return repository.getChartIots(nodeId, startDate, endDate);
  }
}
