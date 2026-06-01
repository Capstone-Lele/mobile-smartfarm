import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kebijakan Privasi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kebijakan Privasi Aplikasi Budidaya Lele',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              '1. Pengumpulan Informasi',
              'Kami mengumpulkan informasi yang Anda berikan secara langsung kepada kami, seperti saat Anda membuat akun, memperbarui profil, atau mengisi laporan budidaya lele Anda. Informasi ini mencakup nama, alamat email, dan data operasional kolam Anda.',
            ),
            _buildSection(
              '2. Penggunaan Informasi',
              'Informasi yang kami kumpulkan digunakan untuk menyediakan, memelihara, dan meningkatkan layanan kami, serta untuk memberikan notifikasi penting terkait kondisi kolam dan alat IoT Anda.',
            ),
            _buildSection(
              '3. Keamanan Data',
              'Kami mengambil langkah-langkah wajar untuk melindungi informasi pribadi Anda dari kehilangan, pencurian, penyalahgunaan, dan akses tidak sah. Kami menggunakan enkripsi standar industri untuk melindungi data sensitif Anda.',
            ),
            _buildSection(
              '4. Berbagi Informasi',
              'Kami tidak akan membagikan informasi pribadi Anda kepada pihak ketiga tanpa izin Anda, kecuali diwajibkan oleh hukum atau untuk keperluan operasional aplikasi yang mendesak.',
            ),
            _buildSection(
              '5. Perubahan Kebijakan',
              'Kami dapat memperbarui kebijakan privasi ini dari waktu ke waktu. Kami akan memberi tahu Anda tentang perubahan apa pun dengan memperbarui tanggal di bagian atas halaman ini.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Terakhir diperbarui: 7 Mei 2026',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: AppColors.darkGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.darkGray,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
