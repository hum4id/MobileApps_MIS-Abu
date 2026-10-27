import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Satu tujuan navigasi di bottom bar.
class NavDestination {
  const NavDestination({required this.label, required this.icon, required this.path});
  final String label;
  final IconData icon;
  final String path;
}

/// Bottom navigation bar ala "GNav": item terpilih mengembang jadi pill
/// berisi ikon + label, sisanya hanya ikon. Animasi halus, tanpa dependency
/// tambahan. Mengikuti best practice mobile (navigasi utama selalu terlihat).
///
/// Anti-overflow: item terpilih dibungkus [Flexible] sehingga mengambil sisa
/// ruang; labelnya ikut [Flexible] agar ellipsis di layar sempit (<=320px),
/// tapi tampil penuh di layar normal.
class MobileNavBar extends StatelessWidget {
  const MobileNavBar({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onTap,
  });

  final List<NavDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.stroke)),
        boxShadow: [
          BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              for (var i = 0; i < destinations.length; i++)
                _buildItem(i),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int i) {
    final selected = i == currentIndex;
    final item = _NavItem(
      destination: destinations[i],
      selected: selected,
      onTap: () => onTap(i),
    );
    // Item terpilih boleh melebar; item lain tetap seukuran ikonnya.
    return selected
        ? Flexible(child: item)
        : Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: item);
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.destination, required this.selected, required this.onTap});

  final NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.gray500;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: selected ? 16 : 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary50 : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(destination.icon, size: 22, color: color),
            // Label hanya muncul saat item terpilih; Flexible agar aman di layar sempit.
            if (selected)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    destination.label,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
