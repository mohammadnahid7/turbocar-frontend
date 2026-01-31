/// Filter Bottom Sheet
/// Filter options bottom sheet for car listings
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/common/custom_button.dart';
import '../../../data/providers/filter_provider.dart';
import '../../../core/constants/string_constants.dart';
import '../../../core/constants/app_constants.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  // TODO: Get cities from constants or API
  final List<String> cities = ['City 1', 'City 2', 'City 3'];
  final List<String> categories = [
    StringConstants.sedan,
    StringConstants.suv,
    StringConstants.sports,
    StringConstants.hatchback,
    StringConstants.coupe,
    StringConstants.convertible,
    StringConstants.truck,
    StringConstants.van,
  ];
  final List<String> sortOptions = [
    StringConstants.priceHighToLow,
    StringConstants.priceLowToHigh,
    StringConstants.mileage,
    StringConstants.year,
  ];

  RangeValues _priceRange = RangeValues(
    AppConstants.minPrice.toDouble(),
    AppConstants.maxPrice.toDouble(),
  );

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(filterProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            StringConstants.filter,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          // City dropdown
          DropdownButtonFormField<String>(
            initialValue: filterState.city,
            decoration: InputDecoration(labelText: StringConstants.city),
            items: cities.map((city) {
              return DropdownMenuItem(value: city, child: Text(city));
            }).toList(),
            onChanged: (value) {
              ref.read(filterProvider.notifier).updateCity(value);
            },
          ),
          const SizedBox(height: 16),
          // Category button group
          Text(
            StringConstants.category,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: categories.map((category) {
              final isSelected = filterState.model == category;
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  ref
                      .read(filterProvider.notifier)
                      .updateModel(selected ? category : null);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Price range slider
          Text(
            StringConstants.priceRange,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          RangeSlider(
            values: _priceRange,
            min: AppConstants.minPrice.toDouble(),
            max: AppConstants.maxPrice.toDouble(),
            divisions: (AppConstants.maxPrice / AppConstants.priceStep).toInt(),
            labels: RangeLabels(
              '${_priceRange.start.toInt()}',
              '${_priceRange.end.toInt()}',
            ),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
              ref
                  .read(filterProvider.notifier)
                  .updatePriceRange(values.start, values.end);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Min: ${_priceRange.start.toInt()}'),
              Text('Max: ${_priceRange.end.toInt()}'),
            ],
          ),
          const SizedBox(height: 16),
          // Sort options
          Text(
            StringConstants.sortBy,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: sortOptions.map((option) {
              final isSelected = filterState.sortBy == option;
              return FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (selected) {
                  ref
                      .read(filterProvider.notifier)
                      .updateSortBy(selected ? option : null);
                },
              );
            }).toList(),
          ),
          // Buttons
          Row(
            children: [
              Expanded(
                child: CustomButton.outline(
                  onPressed: () {
                    ref.read(filterProvider.notifier).resetFilters();
                    Navigator.pop(context);
                  },
                  text: StringConstants.reset,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: StringConstants.apply,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
