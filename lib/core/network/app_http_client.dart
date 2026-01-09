import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/core/utils/app_session.dart';
import 'package:http/http.dart' as http;

Future<http.Response> safeRequest(
  Future<http.Response> Function() request,
) async {
  final response = await request();
  if (response.statusCode == 401) {
    // Clear session
    await AppSession.clearSession();
    // Navigasi ke login secara global
    AppRoutes.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }
  return response;
}
