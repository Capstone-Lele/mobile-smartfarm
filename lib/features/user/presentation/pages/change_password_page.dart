import 'package:budidaya_lele_mobile/common/widgets/app_button.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

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
            'Ubah Password',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            'Pengaturan',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
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
              AppInputText(
                label: 'Password Lama',
                hint: 'Password Lama',
                controller: _oldPasswordCtrl,
                type: FieldType.password,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password lama harus diisi';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              AppInputText(
                label: 'Password Baru',
                hint: 'Password Baru',
                controller: _newPasswordCtrl,
                type: FieldType.password,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password baru harus diisi';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              AppInputText(
                label: 'Konfirmasi Password',
                hint: 'Konfirmasi Password',
                controller: _confirmPasswordCtrl,
                type: FieldType.password,
                requiredField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password harus diisi';
                  }

                  if (value != _newPasswordCtrl.text) {
                    return 'Konfirmasi password tidak cocok';
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
