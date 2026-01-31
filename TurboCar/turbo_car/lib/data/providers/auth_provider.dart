/// Auth Provider
/// State management for authentication using Riverpod
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../services/storage_service.dart';
import 'saved_cars_provider.dart';

// Auth State
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool isGuest;
  final UserModel? user;
  final String? error;

  final bool isInitialized; // New flag

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.isGuest = false,
    this.user,
    this.error,
    this.isInitialized = false, // Default false
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? isGuest,
    UserModel? user,
    String? error,
    bool? isInitialized,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isGuest: isGuest ?? this.isGuest,
      user: user ?? this.user,
      error: error,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final StorageService _storageService;
  final SavedCarsNotifier _savedCarsNotifier;

  AuthNotifier(
    this._authRepository,
    this._storageService,
    this._savedCarsNotifier,
  ) : super(AuthState());

  // Login
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authRepository.login(email, password);
      await _storageService.setGuestMode(false);

      // Sync saved cars on login (merges local + server)
      await _savedCarsNotifier.syncOnLogin();

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        isGuest: false,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  // Register
  Future<void> register({
    required String email,
    required String phone,
    required String password,
    required String fullName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.register(
        email: email,
        phone: phone,
        password: password,
        fullName: fullName,
      );
      // Logic for after registration (e.g. login?) can also sync if needed
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> sendOtp(String phone) async {
    try {
      await _authRepository.sendOtp(phone);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyOtp(String phone, String code) async {
    try {
      await _authRepository.verifyOtp(phone, code);
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      state = AuthState(isInitialized: true);
    } catch (e) {
      // Clear state even if API call fails
      state = AuthState(isInitialized: true);
      rethrow;
    }
  }

  // Switch to guest mode
  Future<void> switchToGuestMode() async {
    await _storageService.setGuestMode(true);
    state = state.copyWith(isAuthenticated: false, isGuest: true, user: null);
  }

  // Change Password
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _authRepository.changePassword(currentPassword, newPassword);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  // Check auth status on app start
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = await _storageService.getToken();
      final isGuest = await _storageService.isGuestMode();

      if (token != null && token.isNotEmpty && !isGuest) {
        final user = await _authRepository.getCurrentUser();

        // Sync saved cars if already logged in (optional but good for consistency)
        // _savedCarsNotifier.fetchSavedCars(forceSync: true);

        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          isGuest: false,
          user: user,
          isInitialized: true,
        );
      } else if (isGuest) {
        state = state.copyWith(
          isLoading: false,
          isGuest: true,
          isInitialized: true,
        );
      } else {
        state = state.copyWith(isLoading: false, isInitialized: true);
      }
    } catch (e) {
      // If token is invalid, clear it
      await _storageService.clearAll();
      state = state.copyWith(isLoading: false, isInitialized: true);
    }
  }
}

// Auth Provider - Override this in providers.dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  throw UnimplementedError('AuthProvider must be overridden in providers.dart');
});
