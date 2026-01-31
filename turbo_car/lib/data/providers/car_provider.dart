/// Car Provider
/// State management for car listings using Riverpod with caching support
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/car_model.dart';
import '../repositories/car_repository.dart';
import '../../core/constants/app_constants.dart';

// Car List State
class CarListState {
  final bool isLoading;
  final List<CarModel> cars;
  final int currentPage;
  final bool hasMore;
  final String? error;
  final Map<String, dynamic>? filters;
  final bool hasCachedData; // Indicates if cars list has cached data

  CarListState({
    this.isLoading = false,
    this.cars = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.error,
    this.filters,
    this.hasCachedData = false,
  });

  CarListState copyWith({
    bool? isLoading,
    List<CarModel>? cars,
    int? currentPage,
    bool? hasMore,
    String? error,
    Map<String, dynamic>? filters,
    bool? hasCachedData,
  }) {
    return CarListState(
      isLoading: isLoading ?? this.isLoading,
      cars: cars ?? this.cars,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      filters: filters ?? this.filters,
      hasCachedData: hasCachedData ?? this.hasCachedData,
    );
  }
}

// Car List Notifier
class CarListNotifier extends StateNotifier<CarListState> {
  final CarRepository _carRepository;

  CarListNotifier(this._carRepository) : super(CarListState());

  // Fetch cars with filters - supports caching
  Future<void> fetchCars({
    Map<String, dynamic>? filters,
    bool refresh = false,
    bool showCachedWhileLoading = true,
  }) async {
    // If we have cached data and showing cached while loading, don't clear cars
    if (refresh || !showCachedWhileLoading) {
      state = state.copyWith(
        isLoading: true,
        currentPage: 1,
        cars: refresh ? [] : state.cars, // Keep cached data if not refreshing
        hasMore: true,
        error: null,
      );
    } else {
      // Show loading indicator but keep existing cars (cached data)
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final queryParams = {
        'page': refresh ? 1 : state.currentPage,
        'limit': AppConstants.defaultPageSize,
        ...?filters,
        ...?state.filters,
      };

      final response = await _carRepository.fetchCars(queryParams);
      // Backend returns 'data' not 'cars'
      final cars = (response['data'] as List)
          .map((json) => CarModel.fromJson(json as Map<String, dynamic>))
          .toList();
      final hasMore =
          response['has_more'] as bool? ??
          response['hasMore'] as bool? ??
          false;

      state = state.copyWith(
        isLoading: false,
        cars: refresh ? cars : [...state.cars, ...cars],
        currentPage: refresh ? 1 : state.currentPage,
        hasMore: hasMore,
        filters: filters ?? state.filters,
        hasCachedData: true, // Mark as having cached data
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Search cars
  Future<void> searchCars(String query) async {
    if (query.isEmpty) {
      fetchCars(refresh: true);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);
    try {
      final queryParams = {
        'page': 1,
        'limit': AppConstants.defaultPageSize,
        'search': query,
        ...?state.filters,
      };

      final response = await _carRepository.fetchCars(queryParams);
      // Backend returns 'data' not 'cars'
      final cars = (response['data'] as List)
          .map((json) => CarModel.fromJson(json as Map<String, dynamic>))
          .toList();

      state = state.copyWith(
        isLoading: false,
        cars: cars,
        currentPage: 1,
        hasMore: false,
        hasCachedData: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Apply filters
  Future<void> applyFilters(Map<String, dynamic> filters) async {
    await fetchCars(filters: filters, refresh: true);
  }

  // Reset filters
  Future<void> resetFilters() async {
    await fetchCars(filters: {}, refresh: true);
  }

  // Load more
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(currentPage: state.currentPage + 1);
    await fetchCars(refresh: false, showCachedWhileLoading: true);
  }

  // Toggle local favorite status (optimistic UI update)
  void toggleLocalFavorite(String carId) {
    final updatedCars = state.cars.map((car) {
      if (car.id == carId) {
        return car.copyWith(isFavorited: !car.isFavorited);
      }
      return car;
    }).toList();
    state = state.copyWith(cars: updatedCars);
  }
}

// Car List Provider - Override this in providers.dart
final carListProvider = StateNotifierProvider<CarListNotifier, CarListState>((
  ref,
) {
  throw UnimplementedError(
    'CarListProvider must be overridden in providers.dart',
  );
});
