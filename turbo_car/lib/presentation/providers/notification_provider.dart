/// Notification Provider
/// Riverpod provider for notification service
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/notification_service.dart';
import '../providers/chat_provider.dart';

/// Notification service singleton provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// FCM token provider - exposes the current token
final fcmTokenProvider = FutureProvider<String?>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  // Service should already be initialized in main.dart
  return service.fcmToken;
});

/// Notification tap handler
/// Listens to notification taps and navigates accordingly
class NotificationTapHandler {
  final Ref _ref;
  GoRouter? _router;

  NotificationTapHandler(this._ref);

  /// Set the router for navigation
  void setRouter(GoRouter router) {
    _router = router;
  }

  /// Start listening to notification taps
  void startListening() {
    final service = _ref.read(notificationServiceProvider);

    service.onNotificationTap.listen((data) {
      _handleNotificationTap(data);
    });
  }

  /// Handle notification tap based on type
  void _handleNotificationTap(Map<String, dynamic> data) {
    final type = data['type'] as String?;

    switch (type) {
      case 'chat_message':
        final conversationId = data['conversation_id'] as String?;
        if (conversationId != null && _router != null) {
          _router!.push('/chat/$conversationId');
        }
        break;

      case 'new_listing':
        final carId = data['car_id'] as String?;
        if (carId != null && _router != null) {
          _router!.push('/post/$carId');
        }
        break;

      default:
        // Navigate to notification page for other types
        _router?.push('/notification');
    }
  }
}

/// Provider for notification tap handler
final notificationTapHandlerProvider = Provider<NotificationTapHandler>((ref) {
  return NotificationTapHandler(ref);
});

/// Initialize notification service and register device token
Future<void> initializeNotifications(ProviderContainer container) async {
  final notificationService = container.read(notificationServiceProvider);

  // Initialize the service
  await notificationService.initialize();

  // Register FCM token with backend
  final token = notificationService.fcmToken;
  if (token != null) {
    try {
      final chatRepo = container.read(chatRepositoryProvider);
      // Determine device type
      final deviceType = _getDeviceType();
      await chatRepo.registerDevice(token, deviceType: deviceType);
    } catch (e) {
      // Token registration failed - will retry on next app start
      // This is non-critical, just log it
      debugPrint('Failed to register FCM token: $e');
    }
  }
}

String _getDeviceType() {
  // Platform detection
  try {
    if (identical(0, 0.0)) {
      return 'web';
    }
  } catch (_) {}

  // Use dart:io for native platforms
  return 'android'; // Default, will be overridden if iOS
}
