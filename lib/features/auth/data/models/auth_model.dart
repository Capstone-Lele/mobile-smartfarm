import '../../domain/entities/auth.dart';

class AuthModel extends Auth {
  AuthModel({
    required super.expiresAt,
    required super.token,
    required super.type,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      expiresAt: json['expires_at'],
      token: json['token'],
      type: json['type'],
    );
  }
}
