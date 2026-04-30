import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../src/home/datasource/model/response/meal_response.dart';

class LocalStorageService {
  final SharedPreferences prefs;

  LocalStorageService(this.prefs);

  Future<void> saveMeals(String key, List<MealModel> meals) async {
    final jsonList = meals.map((e) => e.toJson()).toList();
    await prefs.setString(key, jsonEncode(jsonList));
  }

  List<MealModel> getMeals(String key) {
    final data = prefs.getString(key);
    if (data == null) return [];

    final List list = jsonDecode(data);
    return list.map((e) => MealModel.fromJson(e)).toList();
  }

  /// FAVORITES
  Future<void> toggleFavorite(MealModel meal) async {
    final favs = getMeals("favorites");

    final exists = favs.any((e) => e.id == meal.id);

    if (exists) {
      favs.removeWhere((e) => e.id == meal.id);
    } else {
      favs.add(meal);
    }

    await saveMeals("favorites", favs);
  }

  List<MealModel> getFavorites() {
    return getMeals("favorites");
  }
}