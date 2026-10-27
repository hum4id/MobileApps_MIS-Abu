import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../app/router/app_router.dart';
import '../responsive/breakpoints.dart';
import '../theme/app_colors.dart';
import 'mobile_nav_bar.dart';

class _MenuItem {
  const _MenuItem(this.label, this.icon, this.path);
  final String label;
  final IconData icon;
  final String path;
}

class _MenuSection {
  const _MenuSection(this.title, this.items);
  final String? title;
  final List<_MenuItem> items;
}

// Struktur sidebar mengikuti Figma: 2 menu atas + grup SALES / MANPOWER / CLIENT DATA.
// TODO: filter per role (Director, Finance, Sales, Project Manager, Production Team).
const _sections = <_MenuSection>[
  _MenuSection(null, [
    _MenuItem('Dashboard', Iconsax.home_2, AppRoutes.dashboard),
    _MenuItem('Production Cost Approval', Iconsax.document_text, AppRoutes.approvals),
  ]),
  _MenuSection('SALES', [
    _MenuItem('Project List', Iconsax.document, AppRoutes.projects),
    _MenuItem('History Project', Iconsax.chart_square, AppRoutes.history),
  ]),
  _MenuSection('MANPOWER', [
    _MenuItem('Data Manpower', Iconsax.people, AppRoutes.manpower),
    _MenuItem('Skill Management', Iconsax.star, AppRoutes.skills),
  ]),
  _MenuSection('CLIENT DATA', [
    _MenuItem('Data Client', Iconsax.profile_2user, AppRoutes.clients),
    _MenuItem('Data Company', Iconsax.buildings_2, AppRoutes.companies),
  ]),
];

/// 4 tujuan utama yang selalu tampil di bottom bar (mobile). Sisanya masuk "More".
/// Best practice: batasi bottom bar ke 4-5 destinasi paling sering dipakai.
const _primaryMobile = <NavDestination>[
  NavDestination(label: 'Dashboard', icon: Iconsax.home_2, path: AppRoutes.dashboard),
  NavDestination(label: 'Projects', icon: Iconsax.document, path: AppRoutes.projects),
  NavDestination(label: 'Approval', icon: Iconsax.document_text, path: AppRoutes.approvals),
  NavDestination(label: 'Manpower', icon: Iconsax.people, path: AppRoutes.manpower),
  NavDestination(label: 'More', icon: Iconsax.category, path: _moreTabPath),
];

/// Path semu untuk tab "More" (tidak punya halaman sendiri, membuka bottom sheet).
const _moreTabPath = '__more__';

String _titleFor(String location) {
  for (final s in _sections) {
    for (final i in s.items) {
      if (location.startsWith(i.path)) return i.label;
    }
  }
  if (location.startsWith(AppRoutes.profile)) return 'Profile';
  return 'Makromedia';
}

/// Kerangka halaman adaptif:
///  - Desktop (>=1024): sidebar permanen 305px di kiri.
///  - Tablet  (600-1024): NavigationRail ikon + label di kiri.
///  - Mobile  (<600): AppBar kontekstual + bottom navigation bar (+ sheet "More").
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return switch (context.screenSize) {
      ScreenSize.desktop => _DesktopShell(location: location, child: child),
      ScreenSize.tablet => _TabletShell(location: location, child: child),
      ScreenSize.mobile => _MobileShell(location: location, child: child),
    };
  }
}

// ----------------------------- DESKTOP -----------------------------
class _DesktopShell extends StatelessWidget {
  const _DesktopShell({required this.location, required this.child});
  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(width: 305, child: _Sidebar(location: location)),
          const VerticalDivider(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ----------------------------- TABLET -----------------------------
class _TabletShell extends StatelessWidget {
  const _TabletShell({required this.location, required this.child});
  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Sidebar yang sama (ListView -> otomatis bisa scroll) tapi lebih ramping.
    return Scaffold(
      body: Row(
        children: [
          SizedBox(width: 260, child: _Sidebar(location: location)),
          const VerticalDivider(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ----------------------------- MOBILE -----------------------------
class _MobileShell extends StatelessWidget {
  const _MobileShell({required this.location, required this.child});
  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Tentukan tab aktif. Jika rute bukan salah satu dari 4 utama -> highlight "More".
    final primaryCount = _primaryMobile.length - 1; // exclude "More"
    var index = _primaryMobile
        .take(primaryCount)
        .toList()
        .indexWhere((d) => location.startsWith(d.path));
    if (index < 0) index = _primaryMobile.length - 1; // "More"

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text(
          _titleFor(location),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.notification, size: 22),
            color: AppColors.gray600,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 4),
            child: GestureDetector(
              onTap: () => context.go(AppRoutes.profile),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary50,
                child: Text('JD',
                    style: TextStyle(
                        color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: MobileNavBar(
        destinations: _primaryMobile,
        currentIndex: index,
        onTap: (i) {
          final dest = _primaryMobile[i];
          if (dest.path == _moreTabPath) {
            _showMoreSheet(context, location);
          } else {
            context.go(dest.path);
          }
        },
      ),
    );
  }
}

/// Bottom sheet "More" berisi semua menu sekunder, dikelompokkan seperti sidebar.
void _showMoreSheet(BuildContext context, String location) {
  // Menu yang belum ada di bottom bar utama.
  const primaryPaths = {
    AppRoutes.dashboard,
    AppRoutes.projects,
    AppRoutes.approvals,
    AppRoutes.manpower,
  };

  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Text('Menu', style: Theme.of(sheetContext).textTheme.titleLarge),
              ),
              for (final s in _sections) ...[
                for (final item in s.items)
                  if (!primaryPaths.contains(item.path))
                    ListTile(
                      leading: Icon(item.icon,
                          color: location.startsWith(item.path)
                              ? AppColors.primary
                              : AppColors.gray600),
                      title: Text(item.label,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: location.startsWith(item.path)
                                  ? AppColors.primary
                                  : AppColors.textPrimary)),
                      selected: location.startsWith(item.path),
                      selectedTileColor: AppColors.primary50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        context.go(item.path);
                      },
                    ),
              ],
              const Divider(height: 24),
              ListTile(
                leading: const Icon(Iconsax.profile_circle, color: AppColors.gray600),
                title: const Text('Profile',
                    style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.go(AppRoutes.profile);
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.logout, color: AppColors.danger),
                title: const Text('Logout',
                    style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.danger)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.go(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ----------------------------- SIDEBAR (desktop) -----------------------------
class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
      alignment: Alignment.center,
      child: const Text('M',
          style: TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.w700)),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        children: [
          Row(children: [
            _Logo(),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Makromedia',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ]),
          const SizedBox(height: 24),
          for (final s in _sections) ...[
            if (s.title != null)
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(s.title!, style: Theme.of(context).textTheme.labelSmall),
              ),
            for (final item in s.items)
              _MenuTile(
                item: item,
                selected: location.startsWith(item.path),
                onTap: () => context.go(item.path),
              ),
          ],
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.item, required this.selected, required this.onTap});

  final _MenuItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppColors.white : AppColors.gray600;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              Icon(item.icon, size: 22, color: fg),
              const SizedBox(width: 16),
              Expanded(
                child: Text(item.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: fg, fontSize: 14, fontWeight: FontWeight.w500)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
