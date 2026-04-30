import '../datasource/model/response/meal_response.dart';

abstract class HomeEvent {}

class LoadHomeData extends HomeEvent {}

class LoadMealDetail extends HomeEvent {
  final String id;
  LoadMealDetail(this.id);
}

class SearchMeals extends HomeEvent {
  final String query;
  SearchMeals(this.query);
}

class ToggleFavorite extends HomeEvent {
  final MealModel meal;

  ToggleFavorite(this.meal);
}