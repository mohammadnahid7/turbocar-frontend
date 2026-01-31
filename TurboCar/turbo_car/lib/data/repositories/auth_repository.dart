/// Auth Repository
/// Handles authentication-related operations
library;

import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;
  final StorageService _storageService;

  AuthRepository(this._authService, this._storageService);

  // Login
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);

      final token = response['access_token'] as String;
      final refreshToken = response['refresh_token'] as String;
      print(token);
      print(refreshToken);
      await _storageService.saveToken(token);
      await _storageService.saveRefreshToken(refreshToken);

      final userData = response['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userData);
      await _storageService.saveUser(user);
      return user;
    } catch (e) {
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
    try {
      await _authService.register(
        email: email,
        phone: phone,
        password: password,
        fullName: fullName,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Send OTP
  Future<void> sendOtp(String phone) async {
    await _authService.sendOtp(phone);
  }

  // Verify OTP
  Future<void> verifyOtp(String phone, String code) async {
    await _authService.verifyOtp(phone, code);
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
  }

  // Get Current User
  Future<UserModel?> getCurrentUser() async {
    try {
      return await _authService.getCurrentUser();
    } catch (e) {
      return null;
    }
  }

  // Update Profile
  Future<UserModel> updateProfile(Map<String, dynamic> userData) async {
    try {
      return await _authService.updateProfile(userData);
    } catch (e) {
      rethrow;
    }
  }

  // Change Password
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _authService.changePassword(currentPassword, newPassword);
    } catch (e) {
      rethrow;
    }
  }
}
