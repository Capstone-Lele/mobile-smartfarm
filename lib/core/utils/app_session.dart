import 'package:d_method/d_method.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AppSession {
  static SharedPreferences? _prefs;

  static const _tokenKey = 'jwt_token';
  static const _idKey = 'user_id';
  static const _nameKey = 'user_name';
  static const _roleKey = 'user_role';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getBearerToken() => _prefs?.getString(_tokenKey);

  static Future<bool> setBearerToken(String token) async {
    final success = await _prefs?.setString(_tokenKey, token) ?? false;
    if (success) {
      _decodeAndSaveUserData(token);
    }
    return success;
  }

  static void _decodeAndSaveUserData(String token) {
    try {
      Map<String, dynamic> payload = JwtDecoder.decode(token);

      _prefs?.setString(_idKey, payload['id']?.toString() ?? '');
      _prefs?.setString(_nameKey, payload['name'] ?? '');
      _prefs?.setString(_roleKey, payload['role'] ?? '');
    } catch (e) {
      DMethod.log("Error decoding token: $e");
    }
  }

  static String? get userId => _prefs?.getString(_idKey);
  static String? get userName => _prefs?.getString(_nameKey);
  static String? get userRole => _prefs?.getString(_roleKey);

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

  static bool get isOwner => userRole == 'owner';
  static bool get isEmployee => userRole == 'employee';
}
