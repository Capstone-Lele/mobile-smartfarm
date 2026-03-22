import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/features/user/presentation/widgets/profile_photo_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfilePage extends StatefulWidget {
  const ChangeProfilePage({super.key});

  @override
  State<ChangeProfilePage> createState() => _ChangeProfilePageState();
}

class _ChangeProfilePageState extends State<ChangeProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: "Muhammad Adib Firmansyah");
  final _emailCtrl = TextEditingController(text: "adib@gmail.com");
  XFile? _profileImage;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildHeader(context), body: _buildFormState());
  }

  AppBar _buildHeader(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ubah Profil',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          const Text(
            'Pengaturan',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFormState() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: ProfilePhotoInput(
                  initialImageUrl: 'https://picsum.photos/201',
                  onChanged: (file) {
                    setState(() {
                      _profileImage = file;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Penanggung Jawab',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              AppInputText(
                label: 'Nama Lengkap',
                hint: 'Nama Lengkap',
                controller: _nameCtrl,
                type: FieldType.text,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppInputText(
                label: 'Email Address',
                hint: 'alex@gmail.com',
                controller: _emailCtrl,
                type: FieldType.email,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email harus diisi';
                  }
                  if (!value.contains('@')) {
                    return 'Masukkan format email yang benar';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              AppButton(label: 'Ubah', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
