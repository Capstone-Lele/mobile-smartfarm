import 'package:budidaya_lele_mobile/core/constants/app_constants.dart';
import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/core/network/app_http_client.dart';
import 'package:budidaya_lele_mobile/core/network/app_request.dart';
import 'package:budidaya_lele_mobile/core/network/app_response.dart';
import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class SamplingReportDatasource {
  // Get Sampling Reports
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getSamplingReports(String poolId) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/note/samplings?poolId=$poolId');
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

   // Get Sampling Report
  Future<Either<Failure, Map<String, dynamic>>> getSamplingReport(
    String id,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/note/sampling/$id');
    final token = AppSession.getBearerToken();

    try {
      final response = await safeRequest(
        () => http
            .get(url, headers: AppRequest.header(token))
            .timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final samplingReport = data['data'][0];
      return Right(samplingReport);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

   // Create Sampling Report
  Future<Either<Failure, Map<String, dynamic>>> createSamplingReport(
    String cycleId,
    String reportDate,
    int quantity,
    double averageWeight,
    XFile image,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/note/sampling');
    final token = AppSession.getBearerToken();

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(AppRequest.header(token));
      request.fields['cycleId'] = cycleId;
      request.fields['reportDate'] = reportDate;
      request.fields['quantity'] = quantity.toString();
      request.fields['averageWeight'] = averageWeight.toString();
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final streamedResponse = await request.send();
      final response = await safeRequest(
        () => http.Response.fromStream(
          streamedResponse,
        ).timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final samplingReport = data['data'][0];
      return Right(samplingReport);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

   // Update Sampling Report
  Future<Either<Failure, Map<String, dynamic>>> updateSamplingReport(
    String id,
    String reportDate,
    int quantity,
    double averageWeight,
    XFile? image,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/note/sampling/$id');
    final token = AppSession.getBearerToken();

    try {
      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll(AppRequest.header(token));
      request.fields['reportDate'] = reportDate;
      request.fields['quantity'] = quantity.toString();
      request.fields['averageWeight'] = averageWeight.toString();
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }
      final streamedResponse = await request.send();
      final response = await safeRequest(
        () => http.Response.fromStream(
          streamedResponse,
        ).timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final samplingReport = data['data'][0];
      return Right(samplingReport);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

   // Delete Sampling Report
  Future<Either<Failure, Map<String, dynamic>>> deleteSamplingReport(
    String id,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/note/sampling/$id');
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