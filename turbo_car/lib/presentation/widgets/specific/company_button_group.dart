/// Company Button Group
/// Horizontal scrollable company filter buttons
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers/filter_provider.dart';

class CompanyButtonGroup extends ConsumerWidget {
  const CompanyButtonGroup({super.key});

  // TODO: Get companies from constants or API
  static const List<String> companies = [
    'All',
    'Toyota',
    'Honda',
    'BMW',
    'Mercedes',
    'Audi',
    'Ford',
    'Chevrolet',
    'Nissan',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterProvider);

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: companies.length,
        itemBuilder: (context, index) {
          final company = companies[index];
          final isAll = company == 'All';
          final isSelected = isAll
              ? filterState.make == null
              : filterState.make == company;

          return Padding(
            padding: const EdgeInsets.only(right: 5),
            child: OutlinedButton(
              onPressed: () {
                ref
                    .read(filterProvider.notifier)
                    .updateMake((isAll || isSelected) ? null : company);
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                foregroundColor: isSelected
                    ? Colors.white
                    : Theme.of(context).appBarTheme.foregroundColor,
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 1,
                ),
              ),
              child: Text(company),
            ),
          );
        },
      ),
    );
  }
}
