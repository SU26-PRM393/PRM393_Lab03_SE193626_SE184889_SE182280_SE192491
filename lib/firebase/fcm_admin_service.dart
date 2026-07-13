import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Gửi FCM push notification bằng HTTP v1 API với OAuth2 service account.
/// Chỉ dùng cho môi trường học tập — không commit file này nếu có user thật.
class FcmAdminService {
  FcmAdminService._();
  static final instance = FcmAdminService._();

  static const _projectId = 'vietmap-flutter';
  static const _clientEmail =
      'firebase-adminsdk-fbsvc@vietmap-flutter.iam.gserviceaccount.com';
  static const _tokenUri = 'https://oauth2.googleapis.com/token';
  static const _fcmScope =
      'https://www.googleapis.com/auth/firebase.messaging';

  // SECURITY FIX: Private key must be loaded from environment variables or secure storage
  // DO NOT commit hardcoded private keys to version control
  // TODO: Load from environment variable or Firebase App Check
  static String? get _privateKey => const String.fromEnvironment(
        'FCM_PRIVATE_KEY',
        defaultValue: '', // Empty string will cause authentication to fail
      ).isEmpty
          ? null
          : const String.fromEnvironment('FCM_PRIVATE_KEY');

  String? _cachedToken;
  DateTime? _tokenExpiry;

  Future<String> _getAccessToken() async {
    if (_cachedToken != null &&
        _tokenExpiry != null &&
        DateTime.now()
            .isBefore(_tokenExpiry!.subtract(const Duration(minutes: 5)))) {
      return _cachedToken!;
    }

    final now = DateTime.now();
    final iat = now.millisecondsSinceEpoch ~/ 1000;
    final exp = iat + 3600;

    final jwt = JWT({
      'iss': _clientEmail,
      'sub': _clientEmail,
      'aud': _tokenUri,
      'iat': iat,
      'exp': exp,
      'scope': _fcmScope,
    });

    final signed = jwt.sign(RSAPrivateKey(_privateKey), algorithm: JWTAlgorithm.RS256);

    final response = await http.post(
      Uri.parse(_tokenUri),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'urn:ietf:params:oauth2:grant-type:jwt-bearer',
        'assertion': signed,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('OAuth2 token error ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    _cachedToken = data['access_token'] as String;
    _tokenExpiry = now.add(
      Duration(seconds: (data['expires_in'] as int?) ?? 3600),
    );
    return _cachedToken!;
  }

  /// Gửi FCM push đến topic. Lỗi chỉ log, không throw — Firestore đã lưu rồi.
  Future<void> sendToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      final accessToken = await _getAccessToken();
      final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
      );

      final payload = {
        'message': {
          'topic': topic,
          'notification': {'title': title, 'body': body},
          if (data != null) 'data': data,
        },
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        debugPrint('[FCM Admin] push → "$topic": $title');
      } else {
        debugPrint('[FCM Admin] push failed ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('[FCM Admin] error: $e');
    }
  }
}
