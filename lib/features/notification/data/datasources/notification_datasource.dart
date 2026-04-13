import 'package:budidaya_lele_mobile/core/constants/app_constants.dart';
import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/core/network/app_http_client.dart';
import 'package:budidaya_lele_mobile/core/network/app_request.dart';
import 'package:budidaya_lele_mobile/core/network/app_response.dart';
import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class NotificationDatasource {
  // Get Notifications
  Future<Either<Failure, List<Map<String, dynamic>>>> getNotifications() async {
    Uri url = Uri.parse('${AppConstants.baseURL}/notifications');
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

  // Get Notification
  Future<Either<Failure, Map<String, dynamic>>> getNotification(
    String id,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/notification/$id');
    final token = AppSession.getBearerToken();

    try {
      final response = await safeRequest(
        () => http
            .get(url, headers: AppRequest.header(token))
            .timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final notification = data['data'][0];
      return Right(notification);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Update Notification
  Future<Either<Failure, Map<String, dynamic>>> updateNotification(
    String id,
    String readedAt,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/notification/$id');
    final token = AppSession.getBearerToken();

    try {
      final response = await safeRequest(
        () => http
            .put(
              url,
              headers: AppRequest.header(token),
              body: {'readedAt': readedAt},
            )
            .timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final notification = data['data'][0];
      return Right(notification);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }
}
