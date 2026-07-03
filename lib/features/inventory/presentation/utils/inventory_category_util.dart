import 'package:budidaya_lele_mobile/features/inventory/domain/entities/inventory.dart';

/// Utilitas untuk menurunkan daftar kategori dari list inventaris.
///
/// Kategori tidak lagi diambil dari endpoint terpisah, melainkan dikumpulkan
/// dari key `category` pada setiap item inventaris.
class InventoryCategoryUtil {
  const InventoryCategoryUtil._();

  /// Mengembalikan daftar nama kategori unik dari [inventories], mengabaikan
  /// item yang sudah dihapus (`deletedAt != null`) dan kategori kosong.
  /// Hasil diurutkan agar posisi filter chip stabil.
  static List<String> deriveCategoryNames(List<Inventory> inventories) {
    final names = <String>{};
    for (final item in inventories) {
      if (item.deletedAt != null) continue;
      if (item.category.isNotEmpty) names.add(item.category);
    }
    final result = names.toList()..sort();
    return result;
  }
}
