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

class UserDatasource {
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

  // Change Password
  Future<Either<Failure, Map<String, dynamic>>> changePassword(
    String oldPassword,
    String newPassword,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/app/change-password');
    final token = AppSession.getBearerToken();

    try {
      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll(AppRequest.header(token));
      request.fields['oldPassword'] = oldPassword;
      request.fields['newPassword'] = newPassword;

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

  // Change Profile
  Future<Either<Failure, Map<String, dynamic>>> changeProfile(
    String name,
    XFile? image,
  ) async {
    Uri url = Uri.parse('${AppConstants.baseURL}/app/user');
    final token = AppSession.getBearerToken();

    try {
      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll(AppRequest.header(token));
      request.fields['name'] = name;
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
      final user = data;
      return Right(user);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(FetchFailure(e.toString()));
    }
  }
}
