import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/features/parameter/presentation/widgets/parameter_card.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ParameterPage extends ConsumerStatefulWidget {
  const ParameterPage({super.key});

  @override
  ConsumerState<ParameterPage> createState() => _ParameterPageState();
}

class _ParameterPageState extends ConsumerState<ParameterPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(poolListNotifierProvider.notifier).getPools();
    });
  }

  @override
  Widget build(BuildContext context) {
    final poolsAsync = ref.watch(poolListNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(context),
      body: SafeArea(
        child: poolsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text(error.toString())),
          data: (pools) {
            // Kolam index 0 akan null, yang merepresentasikan "Semua Kolam"
            final itemCount = pools.length + 1;
            return RefreshIndicator(
              onRefresh: () async {
                await ref.read(poolListNotifierProvider.notifier).getPools();
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: itemCount,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const ParameterCard(pool: null);
                  }
                  return ParameterCard(pool: pools[index - 1]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildHeader(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Manajemen Parameter',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Pengaturan',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.darkGray,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
