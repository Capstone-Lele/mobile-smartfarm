import 'dart:convert';
import 'package:budidaya_lele_mobile/core/error/app_error_mapper.dart';
import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:d_method/d_method.dart';
import 'package:http/http.dart';

class AppResponse {
  static Map<String, dynamic> data(Response response) {
    DMethod.printResponse(response);

    switch (response.statusCode) {
      case 200: // read
      case 201: // create, update
        var responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        return responseBody;
      // case 204: // delete
        // return {'success': true};
      case 400:
        // Bad Request / Invalid Input
        final errorMsg = _extractErrorMessage(response.body);
        throw InvalidInputFailure(errorMsg);
      case 401:
        // Unauthorized - session expired
        final errorMsg = _extractErrorMessage(response.body);
        throw UnauthorizedFailure(errorMsg);
      case 403:
        // Forbidden - no access
        final errorMsg = _extractErrorMessage(response.body);
        throw ForbiddenFailure(errorMsg);
      case 404:
        // Not Found
        final errorMsg = _extractErrorMessage(response.body);
        throw NotFoundFailure(errorMsg);
      case 500:
      case 502:
      case 503:
        // Server errors
        final errorMsg = _extractErrorMessage(response.body);
        throw ServerFailure(errorMsg);
      default:
        // Unknown error
        throw FetchFailure('Error ${response.statusCode}: ${response.body}');
    }
  }

  static String _extractErrorMessage(String responseBody) {
    try {
      final response = jsonDecode(responseBody) as Map<String, dynamic>;
      return AppErrorMapper.getErrorMessage(response);
    } catch (e) {
      return responseBody;
    }
  }
}
