import 'package:dio/dio.dart';
import 'package:mobile/utils.dart';

class AuthService {
  final String baseUrl = "http://192.168.0.189:8000";
  final _dio = Dio(BaseOptions(validateStatus: (status) => status! < 500));

  Future<String> login(String email, String password, [String otp = ""]) async {
    FormData formData = FormData.fromMap({
      'username': email,
      'password': password,
    });

    try {
      Response response = await _dio.post(
        "$baseUrl/token/",
        data: formData,
        queryParameters: {"otp": otp},
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        storeTokens(data['access_token'], data['refresh_token']);
        return "success";
      } else {
        return response?.data['detail'];
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data['detail'];
      } else {
        return e.message.toString();
      }
    }
    return "Error";
  }

  Future<void> logout() async {
    await deleteTokens();
  }

  Future<String?> getAccessToken() async {
    Map<String, String?> tokens = await retrieveToken();
    return tokens['accessToken'];
  }
}
