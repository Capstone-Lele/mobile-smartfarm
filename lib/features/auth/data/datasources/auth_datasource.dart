import 'package:budidaya_lele_mobile/core/constants/app_constants.dart';
import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/core/network/app_request.dart';
import 'package:budidaya_lele_mobile/core/network/app_response.dart';
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

  // Register Token
  Future<Either<Failure, Map<String, dynamic>>> registerToken(
    String fcmToken,
    String deviceName,
    String deviceType,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/device/register');
    try {
      final response = await http
          .post(
            url,
            headers: AppRequest.header(),
            body: {
              'fcm_token': fcmToken,
              'device_name': deviceName,
              'device_type': deviceType,
            },
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

  // Unregister Token
  Future<Either<Failure, Map<String, dynamic>>> unregisterToken(
    String fcmToken,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/device/unregister');
    try {
      final response = await http
          .post(
            url,
            headers: AppRequest.header(),
            body: {'fcm_token': fcmToken},
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
}
