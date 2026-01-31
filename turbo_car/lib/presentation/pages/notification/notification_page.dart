/// Notification Page
/// Notifications page (placeholder)
library;

import 'package:flutter/material.dart';
import '../../../core/constants/string_constants.dart';
import '../../widgets/common/custom_app_bar.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: StringConstants.notificationPageTitle),
      body: const Center(
        child: Text(StringConstants.notificationFeatureComingSoon),
      ),
    );
    // TODO: Implement notifications functionality
  }
}
