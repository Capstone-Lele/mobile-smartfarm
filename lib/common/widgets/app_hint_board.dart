import 'package:budidaya_lele_mobile/core/constants/app_assets.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:flutter/material.dart';

class AppHintBoard extends StatefulWidget {
  final String title, desc;

  const AppHintBoard({super.key, required this.title, required this.desc});

  @override
  State<AppHintBoard> createState() => _AppHintBoardState();
}

class _AppHintBoardState extends State<AppHintBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightGray,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.desc,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.lightGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    return Text(
                      AppFormat.currentDateTime(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.lightGray,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 2),
          Image.asset(AppAssets.logo, height: 52, width: 52),
        ],
      ),
    );
  }
}
