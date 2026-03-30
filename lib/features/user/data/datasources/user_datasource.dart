import 'package:budidaya_lele_mobile/core/constants/app_constants.dart';
import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/core/network/app_http_client.dart';
import 'package:budidaya_lele_mobile/core/network/app_request.dart';
import 'package:budidaya_lele_mobile/core/network/app_response.dart';
import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class UserDatasource {
  // Get User Info
  Future<Either<Failure, Map<String, dynamic>>> getUserInfo() async {
    Uri url = Uri.parse('${AppConstants.baseURL}/app/user-info');
    final token = AppSession.getBearerToken();

    try {
      final response = await safeRequest(
        () => http
            .get(url, headers: AppRequest.header(token))
            .timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final result = data['data'];
      return Right(result);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Change Password
  Future<Either<Failure, Map<String, dynamic>>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/app/change-password');
    final token = AppSession.getBearerToken();

    try {
      final response = await safeRequest(
        () => http
            .put(
              url,
              headers: AppRequest.header(token),
              body: {'oldPassword': oldPassword, 'newPassword': newPassword},
            )
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
