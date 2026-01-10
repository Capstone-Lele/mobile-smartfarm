import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AppSession {
  static SharedPreferences? _prefs;

  static const _tokenKey = 'jwt_token';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getBearerToken() => _prefs?.getString(_tokenKey);

  static Future<bool> setBearerToken(String token) async {
    return await _prefs?.setString(_tokenKey, token) ?? false;
  }

  static bool isTokenValid() {
    final token = getBearerToken();

    if (token == null) return false;

    try {
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      return false;
    }
  }

  static bool get isUserLoggedIn => (getBearerToken()?.isNotEmpty ?? false);

  static Future<void> clearSession() async {
    await _prefs?.clear();
  }
}
