import 'package:budidaya_lele_mobile/common/widgets/app_category_filter.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_date_range_filter.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_segmented_control.dart';
import 'package:budidaya_lele_mobile/common/widgets/app_status_badge.dart';
import 'package:budidaya_lele_mobile/core/constants/app_colors.dart';
import 'package:budidaya_lele_mobile/core/utils/app_routers.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/providers/inventory_provider.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/widgets/inventory_card.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/widgets/inventory_submission_card.dart';
import 'package:budidaya_lele_mobile/features/inventory/presentation/widgets/inventory_summary_card.dart';
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

  final List<Map<String, dynamic>> _inventory = [
    {
      'id': 1,
      'product': 'Pakan Pelet 781-1',
      'quantity': '150 Kg',
      'status': 'Cukup',
      'date': 'Senin, 28 Oktober 2025',
    },
    {
      'id': 2,
      'product': 'Pakan Pelet 781-2',
      'quantity': '2 Kg',
      'status': 'Kritis',
      'date': 'Senin, 28 Oktober 2025',
    },
    {
      'id': 3,
      'product': 'Vitamin A',
      'quantity': '10 liter',
      'status': 'Rendah',
      'date': 'Senin, 28 Oktober 2025',
    },
  ];

  final List<Map<String, dynamic>> _inventorySubmission = [
    {
      'id': 1,
      'product': 'Pakan Pelet 781-1',
      'quantity': '150 Kg',
      'status': 'Disetujui',
      'date': 'Senin, 28 Oktober 2025',
    },
    {
      'id': 2,
      'product': 'Pakan Pelet 781-2',
      'quantity': '2 Kg',
      'status': 'Tertunda',
      'date': 'Senin, 28 Oktober 2025',
    },
    {
      'id': 3,
      'product': 'Vitamin A',
      'quantity': '10 liter',
      'status': 'Ditolak',
      'date': 'Senin, 28 Oktober 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(inventoryTabProvider);
    final selectedCategory = ref.watch(inventoryCategoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 16),
                  _buildSummarySection(),
                  SizedBox(height: 16),
                  AppSegmentedControl(
                    children: const ["Stok", "Pengajuan", "Laporan Inventaris"],
                    selectedIndex: selectedTab,
                    onValueChanged: (index) {
                      ref.read(inventoryTabProvider.notifier).state = index;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (selectedTab == 0) ...[
                    AppCategoryFilter(
                      categories: const [
                        "Semua",
                        "Material",
                        "Pakan",
                        "Vitamin",
                      ],
                      selectedIndex: selectedCategory,
                      onCategoryChanged: (index) {
                        ref.read(inventoryCategoryProvider.notifier).state =
                            index;
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
                  ],
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
                  ListView.builder(
                    itemCount: selectedTab == 0
                        ? _inventory.length
                        : _inventorySubmission.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (selectedTab == 0) {
                        final item = _inventory[index];
                        return InventoryCard(
                          productName: item['product'],
                          quantity: item['quantity'],
                          lastUpdate: item['date'],
                          status: item['status'],
                          badgeType: item['status'] == 'Cukup'
                              ? BadgeType.success
                              : item['status'] == 'Rendah'
                              ? BadgeType.warning
                              : BadgeType.danger,
                          onTap: () {
                            AppRoutes.pushNamed(
                              context,
                              AppRoutes.inventoryDetail,
                            );
                          },
                        );
                      } else {
                        final item = _inventorySubmission[index];
                        return InventorySubmissionCard(
                          productName: item['product'],
                          quantity: item['quantity'],
                          submissionDate: item['date'],
                          status: item['status'],
                          badgeType: item['status'] == 'Disetujui'
                              ? BadgeType.success
                              : item['status'] == 'Tertunda'
                              ? BadgeType.warning
                              : BadgeType.danger,
                          onTap: () {
                            AppRoutes.pushNamed(
                              context,
                              AppRoutes.inventorySubmissionDetail,
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: selectedTab != 0
          ? _buildFloatingActionButton()
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

  Widget _buildSummarySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InventorySummaryCard(
          title: "Total Item",
          value: "12",
          icon: Icons.inventory_2,
        ),
        InventorySummaryCard(
          title: "Stok Rendah",
          value: "6",
          icon: Icons.inventory_2,
        ),
        InventorySummaryCard(
          title: "Kritis",
          value: "2",
          icon: Icons.inventory_2,
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: AppColors.secondary,
      onPressed: () {
        AppRoutes.pushNamed(context, AppRoutes.createnInventorySubmission);
      },
      child: const Icon(Icons.add, color: Colors.white, size: 30),
    );
  }
}
