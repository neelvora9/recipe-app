import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/local_data/local_storage_service.dart';
import '../datasource/model/repo/home_repo.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepo _homeRepo;
  final LocalStorageService _local;

  HomeBloc(this._homeRepo, this._local) : super(const HomeState()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<LoadMealDetail>(_onLoadMealDetail);
    on<SearchMeals>(_onSearchMeals);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  /// ---------------- TIME ----------------
  String _getMealCategory() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) return "Breakfast";
    if (hour >= 11 && hour < 16) return "Chicken";
    return "Seafood";
  }

  /// ---------------- LOCATION ----------------
  Future<String> _getArea() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final country = placemarks.first.country ?? "";
      return _mapCountryToArea(country);
    } catch (_) {
      return "American";
    }
  }

  String _mapCountryToArea(String country) {
    switch (country) {
      case "India":
        return "Indian";
      case "United States":
        return "American";
      default:
        return "American";
    }
  }

  /// ---------------- EVENTS ----------------

  Future<void> _onLoadHomeData(
      LoadHomeData event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final category = _getMealCategory();
      final area = await _getArea();

      final timeMeals = await _homeRepo.getMealsByCategory(category);
      final locationMeals = await _homeRepo.getMealsByArea(area);

      emit(state.copyWith(
        isLoading: false,
        mealsByTime: timeMeals,
        mealsByLocation: locationMeals,
        isOffline: timeMeals.isEmpty || locationMeals.isEmpty,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadMealDetail(
      LoadMealDetail event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final meal = await _homeRepo.getMealDetail(event.id);

      emit(state.copyWith(
        isLoading: false,
        selectedMeal: meal,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onSearchMeals(
      SearchMeals event,
      Emitter<HomeState> emit,
      ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(searchResults: []));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final results = await _homeRepo.searchMeals(event.query);

      emit(state.copyWith(
        isLoading: false,
        searchResults: results,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event,
      Emitter<HomeState> emit,
      ) async {
    await _local.toggleFavorite(event.meal);

    final favs = _local.getFavorites();

    emit(state.copyWith(favorites: favs));
  }
}