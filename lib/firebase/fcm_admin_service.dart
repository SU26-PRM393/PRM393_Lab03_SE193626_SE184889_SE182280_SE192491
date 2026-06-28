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

  // Service account private key — chỉ dùng cho học tập/demo
  static const _privateKey =
      '-----BEGIN PRIVATE KEY-----\n'
      'MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCvDWCxvqTs9sQy\n'
      'VcdmOF1Y5aCtvVGsvZoMsMT8QGDIAFoIkztJHhJ1TWr/iVdmCPfcjmwK2gIswfph\n'
      'G5T7eKMG7dYLd6FAoJtpHf5BUGSG8uq7+Y4xgjyccfpFTeR26k9kilGU2ynh/mko\n'
      'dNoYaWAxdNnJRbtFwcVYeBixTYKlEUrEq/jtK7m+X/qBLFC1MCngGstZcGa72u5V\n'
      'zSQ9gUGKtm+LfVQ1Grtn5AoUhpeZMGexVQYGMrq1UG+X1FsYCxbuk+Re5XbipdOr\n'
      'yMnRPvDFNycC97/nixYIdxDwb7RMx7m2UWZoOajQ96pXvflpM8Z/1Hsx35RHe6//\n'
      'tYEinZJBAgMBAAECggEAQeSxwMaoM3DiQqZKdF6EOOnbNXs9yt3mJp/FzsR3CeIk\n'
      'AfVWDDxvK0u0mrM6vHRkxNexsNYGmo18L+CfkJeFGp8dgtyJzReH2KZLJo/Z/3hi\n'
      'Rtb2IQnKwgMfd8YN2Xty3kA43GUxW1oWgH2X+Td1V7iKIHsItwXtQNOYS+mG45ZC\n'
      '38ZTqSO6r+ZFobt6TreE0RykpIYOoKKxb32bj5zRcIF7fl5e8WyMCleB3z1AoFE7\n'
      'pcEbU5pKB8/JhIuAaM3KZkCSxhf8p6vUlPNp/K9OQIm1LmNV+g/rFfClqL+yvsfI\n'
      'Q6SkiV0pl01wlsBLMYpLxD4zeGYW5h77IOBRMg+htwKBgQDXD0FLIPGqahC4yf6L\n'
      'SXa9LQw55uIWprI/ja0PNrWg8gth9KR/FB0xZe4cVEkm/88MFqTOBp08jRqJcKEt\n'
      '/PAzkJFdjdr9+9t1+NHDQm9Hwja/8P3jjidwCvRNGe1/j0x2/pBxPVgTPKStz8Mi\n'
      '8pYE+2RLOKNotVsqStLGqhFJDwKBgQDQYGZHlof75Y87Urn7a/GsfekalzTAPhKl\n'
      'Y3Nac+xUmyYtq/9C3qeB5NOCs9fZPJ1qiYLv4pgV8XEPpzpuKZg+EY5lMAPxQ856\n'
      'Wk63+xQZMNPghMSt1vWgwFMSBqJha1sshD4K3GbSmP0HNRKQ1Yqp9fG5PfEX5g8Y\n'
      'rh7Lxq9PrwKBgQCL6B23DXCKR8QnIymYXauEeGjqxjwxNjLhy35ZVmMkmDI1gJz/\n'
      'Gwu+1ivofCC24VZF6/k9GupxuO4ZmY8RxupQ8WzQKvfboVxtS/jSiUaxrTRG/DV/\n'
      'MzyO1GGIQyTRhlzdUNCRCrJgmWQcuvucoapdBVqC4Q7VkJ4FTnX+zia+mwKBgFrZ\n'
      'PJ6HjcAQRNNLbRSl6lcXCjNyqygJqB19b4SHOAlnH00YSRFBe+yQ9HpuqHPpDoSt\n'
      'cW3e8AnZGz8E3N+8uMiO5PNO7NkahAIqL1ndWNTmyemAWTOlna+5Sj54sAEjSjvt\n'
      'aBNaJmY5F1A2HmMRBwS02u+1htCxl/FdsMWNWU+3AoGBALat8A/MeGrdwjlh1NEI\n'
      'r+Ih8vq4N1ycI0c5ZjhJ1S3Toq8QFx/I2I2NnvSVShT+PUEHsI88+L1QQqH+5zqn\n'
      'Z1twOFmglDiv9O/HUGJ79VV3o+ex5w5nnIu+2SF7p2euBhOUE0QhSuoSrI5VWyET\n'
      '65IWbD4Oz7i85QPykcftUekP\n'
      '-----END PRIVATE KEY-----\n';

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
