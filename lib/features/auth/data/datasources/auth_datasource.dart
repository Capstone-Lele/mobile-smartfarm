import 'package:budidaya_lele_mobile/core/constants/app_constants.dart';
import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/core/network/app_http_client.dart';
import 'package:budidaya_lele_mobile/core/network/app_request.dart';
import 'package:budidaya_lele_mobile/core/network/app_response.dart';
import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class AuthDatasource {
  // Login
  Future<Either<Failure, Map<String, dynamic>>> login(
    String email,
    String password,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/auth/login');
    try {
      final response = await http
          .post(
            url,
            headers: AppRequest.header(),
            body: {'email': email, 'password': password},
          )
          .timeout(const Duration(seconds: 10));

      final data = AppResponse.data(response);
      final result = data['data'];
      return Right(result);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

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
}
