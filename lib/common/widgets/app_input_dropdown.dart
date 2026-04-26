import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class AppInputDropdown<T> extends StatefulWidget {
  final String? label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final bool requiredField;
  final String? Function(T?)? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<T?>? onChanged;
  final bool readOnly;

  const AppInputDropdown({
    super.key,
    this.label,
    required this.hint,
    required this.items,
    required this.itemLabel,
    this.value,
    this.requiredField = false,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  State<AppInputDropdown<T>> createState() => _AppInputDropdownState<T>();
}

class _AppInputDropdownState<T> extends State<AppInputDropdown<T>> {
  late T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(AppInputDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && !widget.items.contains(widget.value)) {
      _selectedValue = null;
    } else {
      _selectedValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              if (widget.requiredField) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField2<T?>(
          isExpanded: true,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(fontSize: 14, color: Colors.black),
            errorStyle: const TextStyle(
              color: AppColors.red,
              fontSize: 12,
              height: 1.2,
            ),
            filled: true,
            fillColor: AppColors.lightGray,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.readOnly ? Colors.transparent : AppColors.gray,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.readOnly
                    ? Colors.transparent
                    : AppColors.darkGray,
                width: widget.readOnly ? 1 : 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.red, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.gray, width: 1),
            ),
          ),
          value: _selectedValue,
          selectedItemBuilder: (BuildContext context) {
            return [
              Text(
                widget.hint,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              ...widget.items.map((item) {
                return Text(
                  widget.itemLabel(item),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                );
              }),
            ];
          },
          items: [
            DropdownMenuItem<T?>(
              value: null,
              child: Text(
                widget.hint,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            ...widget.items.map((item) {
              return DropdownMenuItem<T?>(
                value: item,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.itemLabel(item),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (_selectedValue == item)
                      const Icon(Icons.check, color: AppColors.green, size: 20),
                  ],
                ),
              );
            }),
          ],
          onChanged: widget.readOnly
              ? null
              : (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                  widget.onChanged?.call(value);
                },
          validator: widget.validator,
          autovalidateMode:
              widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            scrollbarTheme: ScrollbarThemeData(
              thickness: WidgetStateProperty.all(6),
              thumbVisibility: WidgetStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            height: 40,
          ),
        ),
      ],
    );
  }
}
