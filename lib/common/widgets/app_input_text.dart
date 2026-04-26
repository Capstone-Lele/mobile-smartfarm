import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum FieldType { text, email, number, password }

class AppInputText extends StatefulWidget {
  final String? label;
  final String hint;
  final TextEditingController? controller;
  final FieldType type;
  final bool requiredField;
  final Widget? prefix;

  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final bool readOnly;
  final int maxLines;
  final int minLines;

  const AppInputText({
    super.key,
    this.label,
    required this.hint,
    this.controller,
    this.type = FieldType.text,
    this.requiredField = false,
    this.prefix,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.maxLength,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines = 1,
  });

  @override
  State<AppInputText> createState() => _AppInputState();
}

class _AppInputState extends State<AppInputText> {
  bool _obscure = true;

  TextInputType get _keyboardType {
    switch (widget.type) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.number:
        return TextInputType.number;
      case FieldType.password:
      case FieldType.text:
        return TextInputType.text;
    }
  }

  bool get _isPassword => widget.type == FieldType.password;

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
        TextFormField(
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          controller: widget.controller,
          keyboardType: _keyboardType,
          obscureText: _isPassword ? _obscure : false,
          readOnly: widget.readOnly,
          validator: widget.validator,
          autovalidateMode:
              widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
          onChanged: widget.onChanged,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(fontSize: 14, color: AppColors.darkGray),
            errorStyle: const TextStyle(
              color: AppColors.red,
              fontSize: 12,
              height: 1.2,
            ),

            filled: true,
            fillColor: AppColors.lightGray,
            contentPadding: const EdgeInsets.only(
              top: 12,
              bottom: 12,
              left: 0,
              right: 12,
            ),
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
            prefixIcon: widget.prefix != null
                ? Padding(
                    padding: EdgeInsets.only(left: 12, right: 8),
                    child: widget.prefix,
                  )
                : const SizedBox(width: 12),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 12,
              minHeight: 0,
            ),
            suffixIcon: _isPassword && !widget.readOnly
                ? IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.darkGray,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
