import 'package:myapp/config/data/dio/dio_client.dart';
import 'package:myapp/src/home/datasource/model/repo/home_repo.dart';

import '../../../../../core/callbacks/callbacks.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/local_data/home_local_datasource.dart';
import '../response/meal_response.dart';

class HomeRepoImpl implements HomeRepo {
  final DioClient _dioClient;
  final HomeLocalDataSource _local;

  HomeRepoImpl({
    required DioClient dioClient,
    required HomeLocalDataSource local,
  })  : _dioClient = dioClient,
        _local = local;

  @override
  Future<List<MealModel>> getMealsByCategory(String category) async {
    try {
      final res = await _dioClient.get(
        "https://www.themealdb.com/api/json/v1/1/filter.php?c=$category",
      );

      final List list = res.data["meals"] ?? [];
      final meals = list.map((e) => MealModel.fromJson(e)).toList();

      /// ✅ SAVE CACHE
      await _local.saveMeals("category_$category", meals);

      return meals;
    } catch (e) {
      /// ✅ FALLBACK TO CACHE
      return _local.getMeals("category_$category");
    }
  }

  @override
  Future<List<MealModel>> getMealsByArea(String area) async {
    try {
      final res = await _dioClient.get(
        "https://www.themealdb.com/api/json/v1/1/filter.php?a=$area",
      );

      final List list = res.data["meals"] ?? [];
      final meals = list.map((e) => MealModel.fromJson(e)).toList();

      await _local.saveMeals("area_$area", meals);

      return meals;
    } catch (e) {
      return _local.getMeals("area_$area");
    }
  }

  @override
  Future<MealDetailModel?> getMealDetail(String id) async {
    return await repoCallback<MealDetailModel?>(
      name: "getMealDetail",
      callback: () async {
        final res = await _dioClient.get(
          "https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id",
        );

        final meals = res.data["meals"];

        if (meals != null && meals.isNotEmpty) {
          return MealDetailModel.fromJson(meals.first);
        }

        return null;
      },
    );
  }

  @override
  Future<List<MealModel>> searchMeals(String query) async {
    return await repoCallback<List<MealModel>>(
      name: "searchMeals",
      callback: () async {
        final res = await _dioClient.get(
          "https://www.themealdb.com/api/json/v1/1/search.php?s=$query",
        );

        final List list = res.data["meals"] ?? [];

        return list.map((e) => MealModel.fromJson(e)).toList();
      },
    );
  }
}
