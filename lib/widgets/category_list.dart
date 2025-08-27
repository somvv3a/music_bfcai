import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/song_provider.dart';

class CategoryList extends ConsumerWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category == selectedCategory;
        return Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: InkWell(
            onTap: () {
              ref.read(selectedCategoryProvider.notifier).state = category;
            },
            borderRadius: BorderRadius.circular(12.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 150,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blueAccent : const Color(0xFF282828),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
                    : null,
              ),
              child: Center(
                child: Text(
                  category,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}