import 'package:dio/dio.dart';
import 'package:mobile/models/ingredient.dart';
import 'package:mobile/utils.dart';

class IngredientService {
  final String baseUrl = "http://192.168.0.189:8000";
  final _dio = Dio(BaseOptions(validateStatus: (status) => status! < 500));

  Future<String?> getUserToken() async {
    Map<String, String?> token = await retrieveToken();
    return token['accessToken'];
  }

  Future<void> registerIngredient(
      String name, double quantity, String unit, double value) async {
    try {
      Response response = await _dio.post(
        "$baseUrl/ingredient/",
        data: {
          "name": name,
          "quantity": quantity,
          "unit": unit,
          "value": value
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['detail']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<List<Ingredient>> fetchIngredients() async {
    final token = await getUserToken();

    try {
      Response response = await _dio.get(
        "$baseUrl/ingredient/",
        options: Options(
          headers: {
            "Content-Type": "application/json",
//          "Authorization": "Bearer ${token}",
          },
        ),
      );
      if (response.statusCode == 200) {
        List jsonResponse = response.data;
        return jsonResponse
            .map((ingredient) => Ingredient.fromJson(ingredient))
            .toList();
      } else {
        return response.data;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['detail']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
