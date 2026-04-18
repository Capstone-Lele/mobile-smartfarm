import 'package:budidaya_lele_mobile/common/widgets/app_category_filter.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_date_range_filter.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_loading.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_segmented_control.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_format.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_report.dart';
import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory_submission.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/category_provider.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/inventory_report_provider.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/inventory_submission_provider.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/widgets/inventory_card.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/widgets/inventory_report_card.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/widgets/inventory_submission_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(inventoryListNotifierProvider.notifier).getInventories();
      ref
          .read(inventorySubmissionListNotifierProvider.notifier)
          .getInventorySubmissions();
      ref
          .read(inventoryReportListNotifierProvider.notifier)
          .getInventoryReports();
      ref.read(categoryListNotifierProvider.notifier).getCategories();
    });
  }

  Future<void> _refreshData() async {
    final selectedTab = ref.read(inventoryTabProvider);
    switch (selectedTab) {
      case 0:
        await ref.read(inventoryListNotifierProvider.notifier).getInventories();
        break;
      case 1:
        await ref
            .read(inventorySubmissionListNotifierProvider.notifier)
            .getInventorySubmissions();
        break;
      case 2:
        await ref
            .read(inventoryReportListNotifierProvider.notifier)
            .getInventoryReports();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(inventoryTabProvider);
    final selectedCategory = ref.watch(inventoryCategoryProvider);

    final inventoryState = ref.watch(inventoryListNotifierProvider);
    final submissionState = ref.watch(inventorySubmissionListNotifierProvider);
    final reportState = ref.watch(inventoryReportListNotifierProvider);
    final categoryState = ref.watch(categoryListNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),

                  if (selectedTab == 0)
                    inventoryState.when(
                      loading: () => _buildSummaryLoading(3),
                      error: (error, stack) => Center(
                        child: Text(
                          error.toString(),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      data: (data) => _buildStockSummaryCards(data),
                    )
                  else if (selectedTab == 1)
                    submissionState.when(
                      loading: () => _buildSummaryLoading(3),
                      error: (error, stack) => Center(
                        child: Text(
                          error.toString(),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      data: (data) => _buildSubmissionSummaryCards(data),
                    )
                  else
                    reportState.when(
                      loading: () => _buildSummaryLoading(2),
                      error: (error, stack) => Center(
                        child: Text(
                          error.toString(),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      data: (data) => _buildReportSummaryCards(data),
                    ),

                  const SizedBox(height: 16),
                  AppSegmentedControl(
                    children: const ["Stok", "Pengajuan", "Laporan Inventaris"],
                    selectedIndex: selectedTab,
                    onValueChanged: (index) {
                      ref.read(inventoryTabProvider.notifier).state = index;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Filters
                  if (selectedTab == 2) ...[
                    AppDateRangeFilter(
                      startDate: _startDate,
                      endDate: _endDate,
                      onFilter: (start, end) {
                        setState(() {
                          _startDate = start;
                          _endDate = end;
                        });
                      },
                      onReset: () {
                        setState(() {
                          _startDate = null;
                          _endDate = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    AppDateRangeFilter(
                      startDate: _startDate,
                      endDate: _endDate,
                      onFilter: (start, end) {
                        setState(() {
                          _startDate = start;
                          _endDate = end;
                        });
                      },
                      onReset: () {
                        setState(() {
                          _startDate = null;
                          _endDate = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    categoryState.when(
                      loading: () => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: List.generate(3, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: AppLoading(
                                width: 60,
                                height: 32,
                                borderRadius: 20,
                              ),
                            );
                          }),
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Text(
                          error.toString(),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      data: (categories) {
                        final categoryNames = [
                          "Semua",
                          ...categories.map((c) => c.name),
                        ];
                        return AppCategoryFilter(
                          categories: categoryNames,
                          selectedIndex: selectedCategory,
                          onCategoryChanged: (index) {
                            ref.read(inventoryCategoryProvider.notifier).state =
                                index;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // List label
                  Text(
                    selectedTab == 0
                        ? "Daftar Inventaris"
                        : selectedTab == 1
                        ? "Daftar Pengajuan Inventaris"
                        : "Daftar Laporan Inventaris",
                    style: const TextStyle(
                      color: AppColors.darkGray,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Lists
                  if (selectedTab == 0)
                    _buildInventoryList(inventoryState)
                  else if (selectedTab == 1)
                    _buildSubmissionList(submissionState)
                  else
                    _buildReportList(reportState),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: selectedTab != 0
          ? _buildFloatingActionButton(selectedTab)
          : null,
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Menu Aplikasi",
          style: TextStyle(fontSize: 14, color: AppColors.darkGray),
        ),
        Text(
          "Inventaris",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSummaryLoading(int count) {
    return IntrinsicHeight(
      child: Row(
        children: List.generate(count * 2 - 1, (i) {
          if (i.isOdd) return const SizedBox(width: 8);
          return Expanded(child: AppLoading(height: 80, borderRadius: 8));
        }),
      ),
    );
  }

  Widget _buildStockSummaryCards(List<Inventory> data) {
    final total = data.length;
    final rendah = data.where((e) {
      final qty = double.tryParse(e.totalQuantity) ?? 0;
      final min = double.tryParse(e.minQuantity) ?? 0;
      return qty > 0 && qty <= min;
    }).length;
    final kritis = data.where((e) {
      final qty = double.tryParse(e.totalQuantity) ?? 0;
      return qty == 0;
    }).length;

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Total Item',
              value: '$total',
              icon: Icons.inventory_2,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              title: 'Stok Rendah',
              value: '$rendah',
              icon: Icons.warning_amber_rounded,
              valueColor: AppColors.yellow,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              title: 'Kritis',
              value: '$kritis',
              icon: Icons.dangerous_rounded,
              valueColor: AppColors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionSummaryCards(List<InventorySubmission> data) {
    final disetujui = data
        .where(
          (e) =>
              e.status.toLowerCase() == 'disetujui' ||
              e.status.toLowerCase() == 'approved',
        )
        .length;
    final ditolak = data
        .where(
          (e) =>
              e.status.toLowerCase() == 'ditolak' ||
              e.status.toLowerCase() == 'rejected',
        )
        .length;
    final tertunda = data
        .where(
          (e) =>
              e.status.toLowerCase() == 'tertunda' ||
              e.status.toLowerCase() == 'pending',
        )
        .length;

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Disetujui',
              value: '$disetujui',
              icon: Icons.check_circle_outline,
              valueColor: AppColors.green,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              title: 'Ditolak',
              value: '$ditolak',
              icon: Icons.cancel_outlined,
              valueColor: AppColors.red,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCard(
              title: 'Tertunda',
              value: '$tertunda',
              icon: Icons.hourglass_empty,
              valueColor: AppColors.yellow,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportSummaryCards(List<InventoryReport> data) {
    final total = data.length;
    final last = data.isNotEmpty ? data.first : null;
    final lastLabel = last != null
        ? '${last.product} ${last.quantity} ${last.unit}'
        : '-';

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Total Laporan',
              value: '$total',
              icon: Icons.article_outlined,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildSummaryCardText(
              title: 'Terakhir Laporan',
              subtitle: lastLabel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    Color valueColor = Colors.black,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.darkGray),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, size: 20, color: valueColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCardText({
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.darkGray),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList(AsyncValue<List<Inventory>> state) {
    final selectedCategory = ref.watch(inventoryCategoryProvider);

    return state.when(
      loading: () => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            AppLoading(height: 100, borderRadius: 8),
      ),
      error: (error, stack) => Center(
        child: Text(
          error.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      ),
      data: (data) {
        // Filter berdasarkan kategori
        final filtered = data
            .where((item) {
              if (selectedCategory == 0) return true;

              final categoryMap = {1: "Material", 2: "Pakan", 3: "Vitamin"};

              return item.category.toLowerCase() ==
                  (categoryMap[selectedCategory] ?? "").toLowerCase();
            })
            .where((item) {
              // Filter berdasarkan date range
              if (_startDate != null && _endDate != null) {
                try {
                  final parsed = DateTime.parse(item.updatedAt);
                  final dateOnly = DateTime(
                    parsed.year,
                    parsed.month,
                    parsed.day,
                  );
                  final start = DateTime(
                    _startDate!.year,
                    _startDate!.month,
                    _startDate!.day,
                  );
                  final end = DateTime(
                    _endDate!.year,
                    _endDate!.month,
                    _endDate!.day,
                  );
                  if (dateOnly.isBefore(start) || dateOnly.isAfter(end)) {
                    return false;
                  }
                } catch (_) {
                  return false;
                }
              }
              return true;
            })
            .toList();

        if (filtered.isEmpty) {
          return _buildEmptyState('Belum ada data inventaris.');
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final item = filtered[index];
            final qty = double.tryParse(item.totalQuantity) ?? 0;
            final min = double.tryParse(item.minQuantity) ?? 0;
            final String status;
            final BadgeType badgeType;
            if (qty == 0) {
              status = 'Kritis';
              badgeType = BadgeType.danger;
            } else if (qty <= min) {
              status = 'Rendah';
              badgeType = BadgeType.warning;
            } else {
              status = 'Cukup';
              badgeType = BadgeType.success;
            }
            return InventoryCard(
              productName: item.product,
              quantity: '${item.totalQuantity} ${item.unit}',
              lastUpdate: AppFormat.date(item.updatedAt),
              status: status,
              badgeType: badgeType,
              onTap: () {
                AppRoutes.pushNamed(
                  context,
                  AppRoutes.inventoryDetail,
                  arguments: {'inventoryId': item.id},
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSubmissionList(AsyncValue<List<InventorySubmission>> state) {
    final selectedCategory = ref.watch(inventoryCategoryProvider);

    return state.when(
      loading: () => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            AppLoading(height: 100, borderRadius: 8),
      ),
      error: (error, stack) => Center(
        child: Text(
          error.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      ),
      data: (data) {
        // Filter berdasarkan kategori
        final filtered = data
            .where((item) {
              if (selectedCategory == 0) return true;

              final categoryMap = {1: "Material", 2: "Pakan", 3: "Vitamin"};

              return item.category.toLowerCase() ==
                  (categoryMap[selectedCategory] ?? "").toLowerCase();
            })
            .where((item) {
              // Filter berdasarkan date range
              if (_startDate != null && _endDate != null) {
                try {
                  final parsed = DateTime.parse(item.createdAt);
                  final dateOnly = DateTime(
                    parsed.year,
                    parsed.month,
                    parsed.day,
                  );
                  final start = DateTime(
                    _startDate!.year,
                    _startDate!.month,
                    _startDate!.day,
                  );
                  final end = DateTime(
                    _endDate!.year,
                    _endDate!.month,
                    _endDate!.day,
                  );
                  if (dateOnly.isBefore(start) || dateOnly.isAfter(end)) {
                    return false;
                  }
                } catch (_) {
                  return false;
                }
              }
              return true;
            })
            .toList();

        if (filtered.isEmpty) {
          return _buildEmptyState('Belum ada pengajuan inventaris.');
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final item = filtered[index];
            final statusLower = item.status.toLowerCase();
            final BadgeType badgeType;
            final String statusLabel;
            if (statusLower == 'disetujui' || statusLower == 'approved') {
              badgeType = BadgeType.success;
              statusLabel = 'Disetujui';
            } else if (statusLower == 'ditolak' || statusLower == 'rejected') {
              badgeType = BadgeType.danger;
              statusLabel = 'Ditolak';
            } else {
              badgeType = BadgeType.warning;
              statusLabel = 'Tertunda';
            }
            return InventorySubmissionCard(
              productName: item.product,
              quantity: '${item.quantity} ${item.unit}',
              submissionDate: AppFormat.date(item.createdAt),
              status: statusLabel,
              badgeType: badgeType,
              onTap: () {
                AppRoutes.pushNamed(
                  context,
                  AppRoutes.inventorySubmissionDetail,
                  arguments: {'inventorySubmissionId': item.id},
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildReportList(AsyncValue<List<InventoryReport>> state) {
    return state.when(
      loading: () => ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            AppLoading(height: 100, borderRadius: 8),
      ),
      error: (error, stack) => Center(
        child: Text(
          error.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      ),
      data: (data) {
        final filtered = data.where((report) {
          if (_startDate != null && _endDate != null) {
            try {
              final parsed = DateTime.parse(report.reportDate);
              final dateOnly = DateTime(parsed.year, parsed.month, parsed.day);
              final start = DateTime(
                _startDate!.year,
                _startDate!.month,
                _startDate!.day,
              );
              final end = DateTime(
                _endDate!.year,
                _endDate!.month,
                _endDate!.day,
              );
              if (dateOnly.isBefore(start) || dateOnly.isAfter(end)) {
                return false;
              }
            } catch (_) {
              return false;
            }
          }
          return true;
        }).toList();

        if (filtered.isEmpty) {
          return _buildEmptyState('Belum ada laporan inventaris.');
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final item = filtered[index];
            return InventoryReportCard(
              productName: item.product,
              quantity: '${item.quantity} ${item.unit}',
              date: AppFormat.date(item.reportDate),
              imageUrl: item.image,
              onTap: () {
                AppRoutes.pushNamed(
                  context,
                  AppRoutes.inventoryReportDetail,
                  arguments: {'reportId': item.id},
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inbox_outlined,
              size: 72,
              color: AppColors.darkGray,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(color: AppColors.darkGray, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(int selectedTab) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: AppColors.secondary,
      onPressed: () {
        if (selectedTab == 1) {
          AppRoutes.pushNamed(context, AppRoutes.createInventorySubmission);
        } else if (selectedTab == 2) {
          AppRoutes.pushNamed(context, AppRoutes.createInventoryReport);
        }
      },
      child: const Icon(Icons.add, color: Colors.white, size: 30),
    );
  }
}
