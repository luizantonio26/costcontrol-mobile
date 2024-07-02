import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> storeTokens(String accessToken, String refreshToken) async {
  await storage.write(key: 'accessToken', value: accessToken);
  await storage.write(key: 'refreshToken', value: refreshToken);
}

Future<Map<String, String?>> retrieveToken() async {
  String? accessToken = await storage.read(key: 'accessToken');
  String? refreshToken = await storage.read(key: 'refreshToken');
  return {'accessToken': accessToken, 'refreshToken': refreshToken};
}

// Apagar tokens
Future<void> deleteTokens() async {
  await storage.delete(key: 'accessToken');
  await storage.delete(key: 'refreshToken');
}
