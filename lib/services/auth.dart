import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mobile/utils.dart';

class AuthService {
  final String baseUrl = "http://192.168.0.189:8000";
  final _dio = Dio(BaseOptions(validateStatus: (status) => status! < 500));

  Future<Map<String, dynamic>> signin(String name, String email,
      String password, String confirmPassword, DateTime birthdate) async {
    Map<String, dynamic> data = {
      "name": name,
      "email": email,
      "password": password,
      "confirm_password": confirmPassword,
      "birthdate": DateFormat('yyyy-MM-dd').format(birthdate)
    };
    try {
      Response response = await _dio.post(
        "$baseUrl/signin/",
        data: data,
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        String message = await login(data['email'], password);

        return {"success": true, "message": message};
      } else {
        if (response?.data['detail'] is String) {
          return {"success": false, "message": response?.data['detail']};
        } else {
          List<dynamic> errors = response?.data['detail'];
          return {"success": false, "message": errors};
        }
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return {"success": false, "message": e.response?.data['detail']};
        //return e.response?.data['detail'];
      } else {
        //Map<String, dynamic> value = {"sucess": "false"};
        //return value;
        return {"success": false, "message": e.message.toString()};
      }
    }
  }

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
  }

  Future<void> logout() async {
    await deleteTokens();
  }

  Future<String?> getAccessToken() async {
    Map<String, String?> tokens = await retrieveToken();
    return tokens['accessToken'];
  }
}
