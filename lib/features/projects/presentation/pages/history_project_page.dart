import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/data_toolbar.dart';
import '../../../../core/widgets/responsive_data_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/project.dart';
import '../providers/project_providers.dart';

/// Histori proyek yang sudah selesai. Memakai ulang data proyek (mock) dan
/// menyaring secara lokal berdasar pencarian + kategori.
class HistoryProjectPage extends ConsumerStatefulWidget {
  const HistoryProjectPage({super.key});

  @override
  ConsumerState<HistoryProjectPage> createState() => _HistoryProjectPageState();
}

class _HistoryProjectPageState extends ConsumerState<HistoryProjectPage> {
  String _search = '';
  String? _category;

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!context.isMobile) ...[
            Text('History Project', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
          ],
          projects.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Gagal memuat data: $e'),
            data: (all) {
              final categories = {for (final p in all) p.category}.toList()..sort();
              final q = _search.trim().toLowerCase();
              final items = all.where((p) {
                final matchesQuery = q.isEmpty || p.name.toLowerCase().contains(q);
                final matchesCat = _category == null || p.category == _category;
                return matchesQuery && matchesCat;
              }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DataToolbar(
                    searchHint: 'Search by project...',
                    onSearch: (v) => setState(() => _search = v),
                    filter: DropdownButtonFormField<String?>(
                      initialValue: _category,
                      isExpanded: true,
                      decoration: const InputDecoration(prefixIcon: Icon(Iconsax.filter, size: 18)),
                      hint: const Text('All Category'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Category')),
                        for (final c in categories) DropdownMenuItem(value: c, child: Text(c)),
                      ],
                      onChanged: (v) => setState(() => _category = v),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ResponsiveDataView<Project>(
                    items: items,
                    columns: _columns,
                    emptyMessage: 'Belum ada histori proyek.',
                    footer: Text('Showing ${items.length} data out of ${all.length}',
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  static final _columns = <DataColumnDef<Project>>[
    DataColumnDef(
      label: 'Project name',
      flex: 3,
      isTitle: true,
      cell: (_, p) => Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
    ),
    DataColumnDef(label: 'Category', flex: 2, cell: (_, p) => Text(p.category)),
    DataColumnDef(label: 'Project manager', flex: 2, cell: (_, p) => Text(p.manager)),
    DataColumnDef(label: 'Contract Value', flex: 2, cell: (_, p) => Text(Formatters.rupiah(p.contractValue))),
    DataColumnDef(label: 'Event date', flex: 2, cell: (_, p) => Text(Formatters.date(p.eventDate))),
    DataColumnDef(
      label: 'Status',
      flex: 2,
      cell: (_, __) => const StatusBadge(label: 'Completed', tone: BadgeTone.success),
    ),
  ];
}
