import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../responsive/breakpoints.dart';
import '../theme/app_colors.dart';

/// Toolbar standar untuk halaman data: kolom pencarian + filter opsional +
/// tombol aksi opsional. Adaptif: bertumpuk di mobile, satu baris di layar lebar.
///
/// Dipakai ulang oleh Approval, Skill, Client, Company, dst. agar konsisten.
class DataToolbar extends StatelessWidget {
  const DataToolbar({
    super.key,
    required this.searchHint,
    required this.onSearch,
    this.filter,
    this.action,
    this.searchFlex = 3,
    this.filterFlex = 2,
  });

  final String searchHint;
  final ValueChanged<String> onSearch;

  /// Mis. dropdown status/kategori. Null jika tak ada.
  final Widget? filter;

  /// Mis. tombol "Add ...". Null jika tak ada.
  final Widget? action;

  final int searchFlex;
  final int filterFlex;

  @override
  Widget build(BuildContext context) {
    final search = TextField(
      onChanged: onSearch,
      decoration: InputDecoration(
        hintText: searchHint,
        prefixIcon: const Icon(Iconsax.search_normal, size: 18),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stroke),
      ),
      child: context.isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                search,
                if (filter != null) ...[const SizedBox(height: 12), filter!],
                if (action != null) ...[const SizedBox(height: 12), action!],
              ],
            )
          : Row(
              children: [
                Expanded(flex: searchFlex, child: search),
                if (filter != null) ...[
                  const SizedBox(width: 12),
                  Expanded(flex: filterFlex, child: filter!),
                ],
                if (action != null) ...[const SizedBox(width: 12), action!],
              ],
            ),
    );
  }
}
