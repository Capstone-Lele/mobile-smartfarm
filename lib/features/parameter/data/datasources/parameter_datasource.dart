import 'package:budidaya_lele_mobile/core/constants/app_constants.dart';
import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/core/network/app_http_client.dart';
import 'package:budidaya_lele_mobile/core/network/app_request.dart';
import 'package:budidaya_lele_mobile/core/network/app_response.dart';
import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class ParameterDatasource {
  // Update Parameter Global
  Future<Either<Failure, Map<String, dynamic>>> updateParameters(
    List<double> temperatureMax,
    List<double> temperatureNormal,
    List<double> temperatureMin,
    List<double> acidityMax,
    List<double> acidityNormal,
    List<double> acidityMin,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/pool/limit');
    final token = AppSession.getBearerToken();

    try {
      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll(AppRequest.header(token));
      request.fields['temperatureMax'] = temperatureMax.toString();
      request.fields['temperatureNormal'] = temperatureNormal.toString();
      request.fields['temperatureMin'] = temperatureMin.toString();
      request.fields['acidityMax'] = acidityMax.toString();
      request.fields['acidityNormal'] = acidityNormal.toString();
      request.fields['acidityMin'] = acidityMin.toString();

      final streamedResponse = await request.send();
      final response = await safeRequest(
        () => http.Response.fromStream(
          streamedResponse,
        ).timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Update Parameter by pool
  Future<Either<Failure, Map<String, dynamic>>> updateParameter(
    String poolId,
    List<double> temperatureMax,
    List<double> temperatureNormal,
    List<double> temperatureMin,
    List<double> acidityMax,
    List<double> acidityNormal,
    List<double> acidityMin,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/pool/limit/$poolId');
    final token = AppSession.getBearerToken();

    try {
      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll(AppRequest.header(token));
      request.fields['temperatureMax'] = temperatureMax.toString();
      request.fields['temperatureNormal'] = temperatureNormal.toString();
      request.fields['temperatureMin'] = temperatureMin.toString();
      request.fields['acidityMax'] = acidityMax.toString();
      request.fields['acidityNormal'] = acidityNormal.toString();
      request.fields['acidityMin'] = acidityMin.toString();

      final streamedResponse = await request.send();
      final response = await safeRequest(
        () => http.Response.fromStream(
          streamedResponse,
        ).timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }
}
