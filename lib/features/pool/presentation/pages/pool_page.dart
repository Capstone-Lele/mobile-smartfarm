import 'package:budidaya_lele_mobile/common/widgets/app_hint_board.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_input_text.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:flutter/material.dart';

class PoolPage extends StatefulWidget {
  const PoolPage({super.key});

  @override
  State<PoolPage> createState() => _PoolPageState();
}

class _PoolPageState extends State<PoolPage> {
  final List<Map<String, dynamic>> _pools = [
    {
      'id': 1,
      'title': 'Kolam 1',
      'quantity': 1000,
      'category': 'pembenihan',
      'pH': 7.5,
      'temperature': 28.0,
      'image': 'https://picsum.photos/200',
    },
    {
      'id': 2,
      'title': 'Kolam 2',
      'quantity': 1500,
      'category': 'pembesaran',
      'pH': 7.2,
      'temperature': 26.5,
      'image': 'https://picsum.photos/201',
    },
    {
      'id': 3,
      'title': 'Kolam 3',
      'quantity': 2000,
      'category': 'pembenihan',
      'pH': 7.0,
      'temperature': 25.0,
      'image': '',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildHeader(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AppHintBoard(
                  title: '📌 Petunjuk Kolam',
                  desc: '• Ketuk kolam untuk lihat detailnya.',
                ),
                SizedBox(height: 16),
                AppInputText(
                  hint: 'Masukkan nama kolam',
                  prefix: const Icon(Icons.search, color: Colors.grey),
                ),
                SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pools.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final pool = _pools[index];
                    return _buildPoolItem(pool);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
            'Daftar Kolam',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text(
            'Siklus Sedang Aktif',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPoolItem(Map<String, dynamic> pool) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.darkGray),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    pool['image'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: AppColors.gray,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.darkGray,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pool['title'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          AppStatusBadge(
                            label: pool['category'],
                            type: pool['category'] == 'pembenihan'
                                ? BadgeType.warning
                                : pool['category'] == 'pembesaran'
                                ? BadgeType.success
                                : BadgeType.danger,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${pool['pH']} pH',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGray,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${pool['temperature']} °C',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGray,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${pool['quantity']} Ekor Ikan',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.darkGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
