import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/home/datasource/model/response/meal_response.dart';

class HomeLocalDataSource {
  final SharedPreferences prefs;

  HomeLocalDataSource(this.prefs);
  final Box mealsBox = Hive.box('meals');
  final Box favBox = Hive.box('favorites');

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

  // Cache meals
  Future<void> cacheMeals(String key, List<MealModel> meals) async {
    final json = meals.map((e) => e.toJson()).toList();
    await mealsBox.put(key, json);
  }

  List<MealModel> getCachedMeals(String key) {
    final data = mealsBox.get(key);
    if (data == null) return [];
    return (data as List)
        .map((e) => MealModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // Favorites
  Future<void> toggleFavorite(MealModel meal) async {
    final exists = favBox.containsKey(meal.id);

    if (exists) {
      await favBox.delete(meal.id);
    } else {
      await favBox.put(meal.id, meal.toJson());
    }
  }

  List<MealModel> getFavorites() {
    return favBox.values
        .map((e) => MealModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  bool isFavorite(String id) {
    return favBox.containsKey(id);
  }
}