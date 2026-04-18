import 'package:budidaya_lele_mobile/core/constants/app_constants.dart';
import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/core/network/app_http_client.dart';
import 'package:budidaya_lele_mobile/core/network/app_request.dart';
import 'package:budidaya_lele_mobile/core/network/app_response.dart';
import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class ParameterDatasource {
  // Update Parameter
  Future<Either<Failure, Map<String, dynamic>>> updateParameter(
    String poolId,
    String temperatureMax,
    String temperatureMin,
    String acidityMax,
    String acidityMin,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/parameter/$poolId');
    final token = AppSession.getBearerToken();

    try {
      final response = await safeRequest(
        () => http
            .put(
              url,
              headers: AppRequest.header(token),
              body: {
                'temperatureMax': temperatureMax,
                'temperatureMin': temperatureMin,
                'acidityMax': acidityMax,
                'acidityMin': acidityMin,
              },
            )
            .timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final parameter = data['data'][0];
      return Right(parameter);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }
}
