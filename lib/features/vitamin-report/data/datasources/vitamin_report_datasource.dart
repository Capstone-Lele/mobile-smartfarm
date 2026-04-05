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

class VitaminReportDatasource {
  // Get Vitamin Reports
  Future<Either<Failure, List<Map<String, dynamic>>>> getVitaminReports(
    String poolId,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/note/vitamin?poolId=$poolId');
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

  // Get Vitamin Report
  Future<Either<Failure, Map<String, dynamic>>> getVitaminReport(
    String id,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/note/vitamin/$id');
    final token = AppSession.getBearerToken();

    try {
      final response = await safeRequest(
        () => http
            .get(url, headers: AppRequest.header(token))
            .timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final vitaminReport = data['data'][0];
      return Right(vitaminReport);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Create Vitamin Report
  Future<Either<Failure, Map<String, dynamic>>> createVitaminReport(
    String cycleId,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile image,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/note/vitamin');
    final token = AppSession.getBearerToken();

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(AppRequest.header(token));
      request.fields['cycleId'] = cycleId;
      request.fields['inventoryId'] = inventoryId;
      request.fields['reportDate'] = reportDate;
      request.fields['quantity'] = quantity.toString();
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
      final vitaminReport = data['data'][0];
      return Right(vitaminReport);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Update Vitamin Report
  Future<Either<Failure, Map<String, dynamic>>> updateVitaminReport(
    String id,
    String inventoryId,
    String reportDate,
    int quantity,
    XFile? image,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/note/vitamin/$id');
    final token = AppSession.getBearerToken();

    try {
      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll(AppRequest.header(token));
      request.fields['inventoryId'] = inventoryId;
      request.fields['reportDate'] = reportDate;
      request.fields['quantity'] = quantity.toString();
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
      final vitaminReport = data['data'][0];
      return Right(vitaminReport);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Delete Vitamin Report
  Future<Either<Failure, Map<String, dynamic>>> deleteVitaminReport(
    String id,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/note/vitamin/$id');
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
