import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppSegmentedControl extends StatelessWidget {
  final List<String> children;
  final int selectedIndex;
  final Function(int) onValueChanged;

  const AppSegmentedControl({
    super.key,
    required this.children,
    required this.selectedIndex,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(children.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onValueChanged(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 10),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    children[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
