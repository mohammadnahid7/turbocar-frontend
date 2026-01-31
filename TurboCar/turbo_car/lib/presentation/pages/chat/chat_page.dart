/// Chat Page
/// Chat/messaging page with guest mode restriction
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../core/constants/string_constants.dart';
import '../../../core/router/route_names.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';

class ChatPage extends ConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // If guest or not authenticated, show login prompt
    if (authState.isGuest || !authState.isAuthenticated) {
      return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: CustomAppBar(title: StringConstants.chats, isMainNavPage: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 24),
                Text(
                  StringConstants.pleaseLoginToChat,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: StringConstants.loginOrSignup,
                  onPressed: () => context.push(RouteNames.login),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Authenticated user - show chat list placeholder
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: CustomAppBar(title: StringConstants.chats, isMainNavPage: true),
      body: const Center(child: Text(StringConstants.chatFeatureComingSoon)),
    );
    // TODO: Implement chat functionality
  }
}
