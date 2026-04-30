import 'package:equatable/equatable.dart';

import '../datasource/model/response/meal_response.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final List<MealModel> mealsByTime;
  final List<MealModel> mealsByLocation;
  final List<MealModel> searchResults;
  final MealDetailModel? selectedMeal;
  final String? error;
  final bool isOffline;
  final List<MealModel> favorites;

  const HomeState({
    this.isLoading = false,
    this.mealsByTime = const [],
    this.mealsByLocation = const [],
    this.searchResults = const [],
    this.selectedMeal,
    this.error,
    this.isOffline = false,
    this.favorites = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    List<MealModel>? mealsByTime,
    List<MealModel>? mealsByLocation,
    List<MealModel>? searchResults,
    MealDetailModel? selectedMeal,
    String? error,
    bool? isOffline,
    List<MealModel>? favorites,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      mealsByTime: mealsByTime ?? this.mealsByTime,
      mealsByLocation: mealsByLocation ?? this.mealsByLocation,
      searchResults: searchResults ?? this.searchResults,
      selectedMeal: selectedMeal ?? this.selectedMeal,
      error: error,
      isOffline: isOffline ?? this.isOffline,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, mealsByTime, mealsByLocation, searchResults, selectedMeal, error];
}