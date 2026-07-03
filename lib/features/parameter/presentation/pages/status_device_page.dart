import 'package:budidaya_lele_mobile/common/widgets/app_loading.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/network/app_socket.dart';
import 'package:budidaya_lele_mobile/features/dashboard/domain/entities/iot.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/providers/iot_provider.dart';
import 'package:budidaya_lele_mobile/features/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:budidaya_lele_mobile/features/pool/domain/entities/pool.dart';
import 'package:budidaya_lele_mobile/features/pool/presentation/providers/pool_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusDevicePage extends ConsumerStatefulWidget {
  const StatusDevicePage({super.key});

  @override
  ConsumerState<StatusDevicePage> createState() => _StatusDevicePageState();
}

class _StatusDevicePageState extends ConsumerState<StatusDevicePage> {
  @override
  void initState() {
    super.initState();
    AppSocket.instance.connect();
    AppSocket.instance.addPoolDataListener(_onPoolData);
    Future.microtask(() async {
      await ref.read(poolListNotifierProvider.notifier).getPools();
      _joinLoadedPools();
    });
  }

  @override
  void dispose() {
    AppSocket.instance.removePoolDataListener(_onPoolData);
    super.dispose();
  }

  /// Joins the Socket.IO room of every pool so each device status can be
  /// updated in realtime as the node publishes.
  void _joinLoadedPools() {
    final pools = ref.read(poolListNotifierProvider).value ?? [];
    for (final pool in pools) {
      final nodeId = pool.name.replaceAll(RegExp(r'[^0-9]'), '');
      AppSocket.instance.joinPool(nodeId);
    }
  }

  void _onPoolData(Map<String, dynamic> data) {
    if (!mounted) return;
    ref.read(iotListNotifierProvider.notifier).upsertSocketData(data);
  }

  /// Finds the realtime reading that belongs to [pool] (matched by node id).
  Iot? _iotForPool(Pool pool, List<Iot> iots) {
    final nodeId = pool.name.replaceAll(RegExp(r'[^0-9]'), '');
    for (final iot in iots) {
      if (iot.nodeId.toString() == nodeId) return iot;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final poolsAsync = ref.watch(poolListNotifierProvider);
    final iots = ref.watch(iotListNotifierProvider).value ?? [];

    return Scaffold(
      appBar: _buildHeader(context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(poolListNotifierProvider.notifier).getPools();
            _joinLoadedPools();
          },
          child: poolsAsync.when(
            loading: () => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: const [AppLoading(height: 60, borderRadius: 12)],
            ),
            error: (error, stack) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: const [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Text(
                      'Gagal memuat data kolam',
                      style: TextStyle(color: AppColors.darkGray, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            data: (pools) {
              final activePools =
                  pools.where((pool) => pool.deletedAt == null).toList();

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final pool in activePools) ...[
                      _buildPoolCard(pool, _iotForPool(pool, iots)),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              );
            },
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
        children: const [
          Text(
            'Status Alat',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 2),
          Text(
            'Pengaturan',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPoolCard(Pool pool, Iot? iot) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray, width: 1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            pool.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.darkGray,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Daftar Alat',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _buildDeviceItem(
                    'Alat Pengukur pH',
                    DashboardUtils.isPhActive(iot),
                  ),
                  _buildDeviceItem(
                    'Alat Pengukur Suhu',
                    DashboardUtils.isTempActive(iot),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceItem(String name, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.wifi, size: 20, color: AppColors.black),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),
          AppStatusBadge(
            label: isActive ? 'Aktif' : 'Tidak Aktif',
            type: isActive ? BadgeType.success : BadgeType.danger,
          ),
        ],
      ),
    );
  }
}
