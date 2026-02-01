import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppDialog {
  static Future<void> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
    Color? color,
    required Future<void> Function() onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => _ConfirmationDialogBody(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        color: color,
        onConfirm: onConfirm,
      ),
    );
  }
}

class _ConfirmationDialogBody extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? color;
  final Future<void> Function() onConfirm;

  const _ConfirmationDialogBody({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.color,
    required this.onConfirm,
  });

  @override
  State<_ConfirmationDialogBody> createState() =>
      _ConfirmationDialogBodyState();
}

class _ConfirmationDialogBodyState extends State<_ConfirmationDialogBody> {
  bool _isLoading = false;

  void _handleConfirm() async {
    setState(() {
      _isLoading = true;
    });

    await widget.onConfirm();

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: widget.color ?? AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            if (!_isLoading) ...[
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: widget.cancelText,
                      color: widget.color ?? AppColors.primary,
                      isOutlined: true,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: widget.confirmText,
                      color: widget.color ?? AppColors.primary,
                      onPressed: _handleConfirm,
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(
                height: 50,
                child: Center(
                  child: CircularProgressIndicator(
                    color: widget.color ?? AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
