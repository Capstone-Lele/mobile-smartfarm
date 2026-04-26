import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DateFieldType { date, dateTime }

class AppInputDate extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final DateFieldType type;
  final bool requiredField;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<DateTime>? onChanged;
  final bool readOnly;

  const AppInputDate({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.type = DateFieldType.date,
    this.requiredField = false,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.autovalidateMode,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  State<AppInputDate> createState() => _AppInputDateState();
}

class _AppInputDateState extends State<AppInputDate> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
    }

    if (widget.controller?.text.isNotEmpty ?? false) {
      _formatControllerText();
    }
  }

  @override
  void didUpdateWidget(covariant AppInputDate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null) {
      _formatControllerText();
    }
  }

  void _formatControllerText() {
    final currentText = widget.controller?.text;
    if (currentText == null || currentText.isEmpty) return;

    final parsed = _parseDate(currentText);
    if (parsed != null) {
      final formatted = _formatDate(parsed);
      if (currentText != formatted) {
        _selectedDate = parsed;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.controller?.text = formatted;
        });
      } else if (_selectedDate != parsed) {
        _selectedDate = parsed;
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    if (widget.type == DateFieldType.date) {
      return DateFormat('dd-MM-yyyy').format(date);
    } else {
      return DateFormat('dd-MM-yyyy HH:mm').format(date);
    }
  }

  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;

    try {
      // Try ISO 8601 (API format)
      return DateTime.parse(dateString).toLocal();
    } catch (e) {
      try {
        // Try UI DateTime format
        return DateFormat('dd-MM-yyyy HH:mm').parse(dateString);
      } catch (e) {
        try {
          // Try UI Date format
          return DateFormat('dd-MM-yyyy').parse(dateString);
        } catch (e) {
          return null;
        }
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = _selectedDate ?? widget.initialDate ?? now;
    final firstDate = widget.firstDate ?? DateTime(2000);
    final lastDate = widget.lastDate ?? DateTime(2100);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      if (widget.type == DateFieldType.dateTime) {
        if (!mounted) return;
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialDate),
        );

        if (pickedTime != null) {
          final dateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          setState(() {
            _selectedDate = dateTime;
            widget.controller?.text = _formatDate(dateTime);
          });
          widget.onChanged?.call(dateTime);
        }
      } else {
        setState(() {
          _selectedDate = pickedDate;
          widget.controller?.text = _formatDate(pickedDate);
        });
        widget.onChanged?.call(pickedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
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
        TextFormField(
          controller: widget.controller,
          readOnly: true,
          validator: widget.validator,
          autovalidateMode:
              widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
          onTap: widget.readOnly ? null : () => _selectDate(context),
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
            prefixIcon: const SizedBox(width: 12),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 12,
              minHeight: 0,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.calendar_today_outlined,
                color: AppColors.darkGray,
              ),
              onPressed: widget.readOnly ? null : () => _selectDate(context),
            ),
          ),
        ),
      ],
    );
  }
}
