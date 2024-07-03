import 'package:dio/dio.dart';
import 'package:mobile/models/recipe.dart';
import 'package:mobile/utils.dart';

class RecipeService {
  Future<String?> getUserToken() async {
    Map<String, String?> token = await retrieveToken();

    return token['accessToken'];
  }

  Future<List<Recipe>> fetchRecipes() async {
    final String baseUrl = "http://192.168.0.189:8000";
    final _dio = Dio(BaseOptions(validateStatus: (status) => status! < 500));
    final token = await getUserToken();

    try {
      Response response = await _dio.get(
        "$baseUrl/recipe/",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}",
          },
        ),
      );
      if (response.statusCode == 200) {
        List jsonResponse = response.data;
        return jsonResponse.map((recipe) => Recipe.fromJson(recipe)).toList();
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
