/// Show Post Page
/// Page displaying car details (placeholder)
library;

import 'package:flutter/material.dart';
import 'package:turbo_car/presentation/widgets/common/custom_app_bar.dart';
import '../../../core/constants/string_constants.dart';

class ShowPostPage extends StatelessWidget {
  final String carId;

  const ShowPostPage({super.key, required this.carId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: StringConstants.carDetails),
      body: Center(
        child: Text('${StringConstants.carDetailsComingSoon}\nCar ID: $carId'),
      ),
    );
    // TODO: Implement car details display
    // TODO: Fetch car details using carId parameter
  }
}
