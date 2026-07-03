import 'package:budidaya_lele_mobile/core/constants/app_constants.dart';
import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:budidaya_lele_mobile/core/network/app_http_client.dart';
import 'package:budidaya_lele_mobile/core/network/app_request.dart';
import 'package:budidaya_lele_mobile/core/network/app_response.dart';
import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class InventorySubmissionDatasource {
  // Get Inventory Submissions
  Future<Either<Failure, List<Map<String, dynamic>>>>
  getInventorySubmissions() async {
    Uri url = Uri.parse('${AppConstants.baseURL}/inventory/submissions');
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

  // Get Inventory Submission
  Future<Either<Failure, Map<String, dynamic>>> getInventorySubmission(
    String id,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/inventory/submission/$id');
    final token = AppSession.getBearerToken();

    try {
      final response = await safeRequest(
        () => http
            .get(url, headers: AppRequest.header(token))
            .timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final inventorySubmission = data['data'][0];
      return Right(inventorySubmission);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Create Inventory Submission
  Future<Either<Failure, Map<String, dynamic>>> createInventorySubmission(
    String inventoryId,
    int quantity,
    String transactionType,
    String? notes,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/inventory/submission');
    final token = AppSession.getBearerToken();

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll(AppRequest.header(token));
      request.fields['inventoryId'] = inventoryId;
      request.fields['quantity'] = quantity.toString();
      request.fields['transactionType'] = transactionType;
      request.fields['notes'] = notes ?? '';

      final streamedResponse = await request.send();
      final response = await safeRequest(
        () => http.Response.fromStream(
          streamedResponse,
        ).timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final inventorySubmission = data['data'][0];
      return Right(inventorySubmission);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Update Inventory Submission
  Future<Either<Failure, Map<String, dynamic>>> updateInventorySubmission(
    String id,
    String inventoryId,
    int quantity,
    String transactionType,
    String? notes,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/inventory/submission/$id');
    final token = AppSession.getBearerToken();

    try {
      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll(AppRequest.header(token));
      request.fields['inventoryId'] = inventoryId;
      request.fields['quantity'] = quantity.toString();
      request.fields['transactionType'] = transactionType;
      request.fields['notes'] = notes ?? '';

      final streamedResponse = await request.send();
      final response = await safeRequest(
        () => http.Response.fromStream(
          streamedResponse,
        ).timeout(const Duration(seconds: 10)),
      );

      final data = AppResponse.data(response);
      final inventorySubmission = data['data'][0];
      return Right(inventorySubmission);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }

  // Delete Inventory Submission
  Future<Either<Failure, Map<String, dynamic>>> deleteInventorySubmission(
    String id,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/inventory/submission/$id');
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
