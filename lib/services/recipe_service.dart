import 'package:dio/dio.dart';
import 'package:mobile/models/recipe.dart';
import 'package:mobile/utils.dart';

class RecipeService {
  Future<String?> getUserToken() async {
    Map<String, String?> token = await retrieveToken();

    return token['accessToken'];
  }

  Future<Recipe> fetchRecipe(int id) async {
    final String baseUrl = "http://192.168.0.189:8000";
    final _dio = Dio(BaseOptions(validateStatus: (status) => status! < 500));
    final token = await getUserToken();

    try {
      Response response = await _dio.get(
        "$baseUrl/recipe/$id/",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}",
          },
        ),
      );
      if (response.statusCode == 200) {
        return Recipe.fromJson(response.data);
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

  Future<void> addIngredient(
      int recipe_id, int ingredient_id, double quantity) async {
    final String baseUrl = "http://192.168.0.189:8000";
    final _dio = Dio(BaseOptions(validateStatus: (status) => status! < 500));
    final token = await getUserToken();

    try {
      Response response = await _dio.post(
        "$baseUrl/recipe_ingredients/",
        data: {
          "recipe_id": recipe_id,
          "ingredient_id": ingredient_id,
          "quantity": quantity
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}",
          },
        ),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        return;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['detail']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<void> updateIngredient(int id, double quantity) async {
    final String baseUrl = "http://192.168.0.189:8000";
    final _dio = Dio(BaseOptions(validateStatus: (status) => status! < 500));
    final token = await getUserToken();

    try {
      Response response = await _dio.put(
        "$baseUrl/recipe_ingredients/$id/",
        data: {"quantity": quantity},
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}",
          },
        ),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        return;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['detail']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<void> deleteIngredient(int id) async {
    final String baseUrl = "http://192.168.0.189:8000";
    final _dio = Dio(BaseOptions(validateStatus: (status) => status! < 500));
    final token = await getUserToken();

    try {
      Response response = await _dio.delete(
        "$baseUrl/recipe_ingredients/$id/",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}",
          },
        ),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        return;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['detail']);
      } else {
        throw Exception(e.message);
      }
    }
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

  Future<void> deleteRecipe(int id) async {
    final String baseUrl = "http://192.168.0.189:8000";
    final _dio = Dio(BaseOptions(validateStatus: (status) => status! < 500));
    final token = await getUserToken();

    try {
      Response response = await _dio.delete(
        "$baseUrl/recipe/$id",
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}",
          },
        ),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        return;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['detail']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<void> registerRecipe(
      String name, String prepTime, int servings, dynamic base64Image) async {
    final String baseUrl = "http://192.168.0.189:8000";
    final _dio = Dio(BaseOptions(validateStatus: (status) => status! < 500));
    final token = await getUserToken();

    try {
      Response response = await _dio.post(
        "$baseUrl/recipe/",
        data: {
          "name": name,
          "image_url": base64Image,
          "prep_time": prepTime,
          "servings": servings
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}",
          },
        ),
      );
      if (response.statusCode == 201) {
        return;
      } else {
        return;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['detail']);
      } else {}
    }
  }

  Future<void> updateRecipe(int id, String name, String prepTime, int servings,
      dynamic? base64Image) async {
    final String baseUrl = "http://192.168.0.189:8000";
    final _dio = Dio(BaseOptions(validateStatus: (status) => status! < 500));
    final token = await getUserToken();

    try {
      Response response = await _dio.put(
        "$baseUrl/recipe/$id",
        data: {
          "name": name,
          "prep_time": prepTime,
          "servings": servings,
          "image_url": base64Image
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token}",
          },
        ),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        return;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['detail']);
      } else {}
    }
  }
}
