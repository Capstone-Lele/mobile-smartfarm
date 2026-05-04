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

class MortalityReportDatasource {
  // Get Mortality Reports
  Future<Either<Failure, List<Map<String, dynamic>>>> getMortalityReports(
    String poolId,
  ) async {
    Uri url = Uri.parse(
      '${AppConstants.baseURL}/note/mortality?poolId=$poolId',
    );
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

  // Get Mortality Report
  Future<Either<Failure, Map<String, dynamic>>> getMortalityReport(
    String id,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/note/mortality/$id');
    final token = AppSession.getBearerToken();

    try {
      final response = await safeRequest(
        () => http
            .get(url, headers: AppRequest.header(token))
            .timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final mortalityReport = data['data'][0];
      return Right(mortalityReport);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Create Mortality Report
  Future<Either<Failure, Map<String, dynamic>>> createMortalityReport(
    String cycleId,
    String userId,
    String reportDate,
    int quantity,
    XFile image,
    String notes,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/note/mortality');
    final token = AppSession.getBearerToken();

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(AppRequest.header(token));
      request.fields['cycleId'] = cycleId;
      request.fields['userId'] = userId;
      request.fields['reportDate'] = reportDate;
      request.fields['quantity'] = quantity.toString();
      request.fields['notes'] = notes;
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
      final mortalityReport = data['data'][0];
      return Right(mortalityReport);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Update Mortality Report
  Future<Either<Failure, Map<String, dynamic>>> updateMortalityReport(
    String id,
    String reportDate,
    int quantity,
    XFile? image,
    String notes,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/note/mortality/$id');
    final token = AppSession.getBearerToken();

    try {
      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll(AppRequest.header(token));
      request.fields['reportDate'] = reportDate;
      request.fields['quantity'] = quantity.toString();
      request.fields['notes'] = notes;
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
      final mortalityReport = data['data'][0];
      return Right(mortalityReport);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Delete Mortality Report
  Future<Either<Failure, Map<String, dynamic>>> deleteMortalityReport(
    String id,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/note/mortality/$id');
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
