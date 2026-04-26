import 'dart:io';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppInputImage extends StatefulWidget {
  final String label;
  final String hint;
  final bool requiredField;
  final ValueChanged<XFile?>? onChanged;
  final XFile? initialImage;
  final String? imageUrl;
  final double previewHeight;
  final String? Function(XFile?)? validator;
  final AutovalidateMode? autovalidateMode;
  final bool readOnly;

  const AppInputImage({
    super.key,
    required this.label,
    this.hint = 'Tap to add photo',
    this.requiredField = false,
    this.onChanged,
    this.initialImage,
    this.imageUrl,
    this.previewHeight = 200,
    this.validator,
    this.autovalidateMode,
    this.readOnly = false,
  });

  @override
  State<AppInputImage> createState() => _AppInputImageState();
}

class _AppInputImageState extends State<AppInputImage> {
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _hasUserChangedImage = false;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  bool get _hasImage {
    if (_hasUserChangedImage && _selectedImage == null) {
      return false;
    }

    return _selectedImage != null ||
        (widget.imageUrl != null && widget.imageUrl!.isNotEmpty);
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
        FormField<XFile?>(
          initialValue: widget.initialImage,
          validator:
              widget.validator ??
              (value) {
                if (widget.requiredField) {
                  // Jika user sudah hapus gambar
                  if (_hasUserChangedImage && _selectedImage == null) {
                    return '${widget.label} wajib diisi';
                  }

                  // Jika tidak ada file baru dan tidak ada imageUrl
                  if (value == null && widget.imageUrl == null) {
                    return '${widget.label} wajib diisi';
                  }

                  // Jika tidak ada file baru tapi ada imageUrl dan user belum ubah, anggap valid
                  if (value == null &&
                      widget.imageUrl != null &&
                      !_hasUserChangedImage) {
                    return null;
                  }
                }
                return null;
              },
          autovalidateMode:
              widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: widget.readOnly ? null : () => _showImagePicker(field),
                  child: Container(
                    width: double.infinity,
                    height: widget.previewHeight,
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(8),
                      border: widget.readOnly
                          ? null
                          : Border.all(
                              color: field.hasError
                                  ? AppColors.red
                                  : AppColors.gray,
                              width: field.hasError ? 1.5 : 1,
                            ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: _hasImage
                        ? Stack(
                            children: [
                              _buildImagePreview(),
                              if (!widget.readOnly)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () => _showImagePicker(field),
                                      padding: const EdgeInsets.all(8),
                                      constraints: const BoxConstraints(
                                        minWidth: 36,
                                        minHeight: 36,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 48,
                                  color: AppColors.darkGray,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  widget.hint,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.darkGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                if (field.errorText != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    field.errorText!,
                    style: const TextStyle(
                      color: AppColors.red,
                      fontSize: 12,
                      height: 1.2,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImage != null && _selectedImage!.path.isNotEmpty) {
      return Image.file(
        File(_selectedImage!.path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPlaceholder();
        },
      );
    }

    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return Image.network(
        widget.imageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorPlaceholder();
        },
      );
    }

    return _buildErrorPlaceholder();
  }

  Widget _buildErrorPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 48, color: AppColors.darkGray),
          const SizedBox(height: 8),
          Text(
            'Gagal memuat gambar',
            style: TextStyle(color: AppColors.darkGray, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showImagePicker(FormFieldState<XFile?> field) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Gambar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.photo_library, color: AppColors.primary),
                ),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.gallery, field);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.camera_alt, color: AppColors.primary),
                ),
                title: const Text('Ambil Foto'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.camera, field);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(
    ImageSource source,
    FormFieldState<XFile?> field,
  ) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 2000,
        maxHeight: 2000,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        setState(() {
          _selectedImage = image;
          _hasUserChangedImage = true;
        });
        field.didChange(image);
        widget.onChanged?.call(image);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil gambar: ${e.toString()}'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  bool get hasImage => _hasImage;
  bool get hasUserChanged => _hasUserChangedImage;
  XFile? get selectedImage => _selectedImage;
}
