import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppCategoryFilter extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final Function(int) onCategoryChanged;
  final double? height;
  final EdgeInsets? padding;

  const AppCategoryFilter({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategoryChanged,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: List.generate(categories.length, (index) {
            final isSelected = selectedIndex == index;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onCategoryChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    border: Border.all(color: AppColors.primary, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
