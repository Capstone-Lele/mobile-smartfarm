import 'dart:convert';
import 'package:budidaya_lele_mobile/core/error/failure.dart';
import 'package:d_method/d_method.dart';
import 'package:http/http.dart';

class AppResponse {
  static Map data(Response response) {
    DMethod.printResponse(response);

    switch (response.statusCode) {
      case 200: // read
      case 201: // create, update
        var responseBody = jsonDecode(response.body);
        return responseBody;
      case 204: // delete
        return {'success': true};
      case 400:
        // Bad Request / Invalid Input
        throw InvalidInputFailure(response.body);
      case 401:
        // Unauthorized - session expired
        throw UnauthorizedFailure(response.body);
      case 403:
        // Forbidden - no access
        throw ForbiddenFailure(response.body);
      case 404:
        // Not Found
        throw NotFoundFailure(response.body);
      case 500:
      case 502:
      case 503:
        // Server errors
        throw ServerFailure(response.body);
      default:
        // Unknown error
        throw FetchFailure('Error ${response.statusCode}: ${response.body}');
    }
  }
}
