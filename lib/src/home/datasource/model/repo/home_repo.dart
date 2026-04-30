 

import '../response/meal_response.dart';

abstract interface class HomeRepo {
  Future<List<MealModel>> getMealsByCategory(String category);
  Future<List<MealModel>> getMealsByArea(String area);
  Future<MealDetailModel?> getMealDetail(String id);
  Future<List<MealModel>> searchMeals(String query);
}
