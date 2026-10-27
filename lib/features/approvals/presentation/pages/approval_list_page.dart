import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/data_toolbar.dart';
import '../../../../core/widgets/responsive_data_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/approval.dart';
import '../providers/approval_providers.dart';

class ApprovalListPage extends ConsumerWidget {
  const ApprovalListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final approvals = ref.watch(approvalListProvider);
    final status = ref.watch(approvalStatusFilterProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!context.isMobile) ...[
            Text('Production Cost Approval', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
          ],
          DataToolbar(
            searchHint: 'Search by project...',
            onSearch: (v) => ref.read(approvalSearchProvider.notifier).state = v,
            filter: DropdownButtonFormField<ApprovalStatus?>(
              initialValue: status,
              isExpanded: true,
              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.filter, size: 18)),
              hint: const Text('All Status'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Status')),
                for (final s in ApprovalStatus.values)
                  DropdownMenuItem(value: s, child: Text(s.label)),
              ],
              onChanged: (v) => ref.read(approvalStatusFilterProvider.notifier).state = v,
            ),
          ),
          const SizedBox(height: 16),
          approvals.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Gagal memuat data: $e'),
            data: (items) => ResponsiveDataView<Approval>(
              items: items,
              columns: _columns,
              emptyMessage: 'Tidak ada pengajuan ditemukan.',
              onRowTap: (a) {/* TODO: buka detail dokumen */},
              footer: Text('Showing ${items.length} data out of ${items.length}',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
        ],
      ),
    );
  }

  static final _columns = <DataColumnDef<Approval>>[
    DataColumnDef(
      label: 'Project Name',
      flex: 3,
      isTitle: true,
      cell: (_, a) => Text(a.projectName, style: const TextStyle(fontWeight: FontWeight.w600)),
    ),
    DataColumnDef(label: 'Application Document', flex: 2, cell: (_, a) => Text(a.docType.label)),
    DataColumnDef(label: 'Application Date', flex: 2, cell: (_, a) => Text(a.applicationDate)),
    DataColumnDef(
      label: 'Total Cost',
      flex: 2,
      cell: (_, a) => Text(Formatters.rupiah(a.totalCost)),
    ),
    DataColumnDef(
      label: 'Status',
      flex: 2,
      cell: (_, a) => StatusBadge(
        label: a.status.label,
        tone: switch (a.status) {
          ApprovalStatus.revise => BadgeTone.progress,
          ApprovalStatus.pending => BadgeTone.warning,
          ApprovalStatus.approved => BadgeTone.success,
        },
      ),
    ),
    DataColumnDef(
      label: 'Action',
      flex: 1,
      isAction: true,
      cell: (_, a) => IconButton(
        onPressed: () {},
        icon: const Icon(Iconsax.eye, size: 20),
        color: AppColors.primary,
      ),
    ),
  ];
}
