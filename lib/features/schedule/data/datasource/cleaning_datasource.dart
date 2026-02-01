import 'package:budidaya_lele_mobile/core/constants/app_constants.dart';
import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/core/network/app_http_client.dart';
import 'package:budidaya_lele_mobile/core/network/app_request.dart';
import 'package:budidaya_lele_mobile/core/network/app_response.dart';
import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class CleaningDatasource {
  // Get Cleaning Schedules
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getCleaningSchedules() async {
    Uri url = Uri.parse('${AppConstants.baseURL}/schedule/cleaning');
    final token = AppSession.getBearerToken();

    try {
      final response = await safeRequest(
        () => http
            .get(url, headers: AppRequest.header(token))
            .timeout(const Duration(seconds: 10)),
      );
      final data = AppResponse.data(response);
      final list = data['data'] as List<dynamic>;
      final castedList = list.cast<Map<String, dynamic>>();
      return Right(castedList);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Get Cleaning Schedule
  Future<Either<Failure, Map<String, dynamic>>> getCleaningSchedule(
    String id,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/schedule/cleaning/$id');
    final token = AppSession.getBearerToken();

    try {
      final response = await safeRequest(
        () => http
            .get(url, headers: AppRequest.header(token))
            .timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final schedule = data['data'][0];
      return Right(schedule);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Create Cleaning Schedule
  Future<Either<Failure, Map<String, dynamic>>> createCleaningSchedule(
    String poolId,
    String userId,
    String scheduleDate,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/schedule/cleaning');
    final token = AppSession.getBearerToken();

    try {
      final response = await safeRequest(
        () => http
            .post(
              url,
              headers: AppRequest.header(token),
              body: {
                'poolId': poolId,
                'userId': userId,
                'scheduleDate': scheduleDate,
              },
            )
            .timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final schedule = data['data'][0];
      return Right(schedule);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Update Cleaning Schedule
  Future<Either<Failure, Map<String, dynamic>>> updateCleaningSchedule(
    String id,
    String poolId,
    String userId,
    String scheduleDate,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/schedule/cleaning/$id');
    final token = AppSession.getBearerToken();

    try {
      final response = await safeRequest(
        () => http
            .put(
              url,
              headers: AppRequest.header(token),
              body: {
                'poolId': poolId,
                'userId': userId,
                'scheduleDate': scheduleDate,
              },
            )
            .timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final schedule = data['data'][0];
      return Right(schedule);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Delete Cleaning Schedule
  Future<Either<Failure, Map<String, dynamic>>> deleteCleaningSchedule(
    String id,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/schedule/cleaning/$id');
    final token = AppSession.getBearerToken();

    try {
      final response = await safeRequest(
        () => http
            .delete(url, headers: AppRequest.header(token))
            .timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }
}
