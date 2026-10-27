import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/responsive_data_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/manpower.dart';
import '../providers/manpower_providers.dart';

class ManpowerListPage extends ConsumerWidget {
  const ManpowerListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final people = ref.watch(manpowerListProvider);
    final pad = context.pagePadding;

    return SingleChildScrollView(
      padding: EdgeInsets.all(pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!context.isMobile) ...[
            Text('Data Manpower', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
          ],
          const _Toolbar(),
          const SizedBox(height: 16),
          people.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Gagal memuat data: $e'),
            data: (items) => ResponsiveDataView<Manpower>(
              items: items,
              columns: _columns,
              emptyMessage: 'Tidak ada karyawan ditemukan.',
              onRowTap: (m) {/* TODO: context.go('/manpower/${m.id}') */},
              footer: Text('Showing ${items.length} data out of ${items.length}',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
        ],
      ),
    );
  }

  static final _columns = <DataColumnDef<Manpower>>[
    DataColumnDef(
      label: 'Employee Name',
      flex: 3,
      isTitle: true,
      cell: (_, m) => Text(m.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
    ),
    DataColumnDef(
      label: 'Status',
      flex: 2,
      cell: (_, m) => StatusBadge(
        label: m.employmentStatus.label,
        tone: switch (m.employmentStatus) {
          EmploymentStatus.fulltime => BadgeTone.info,
          EmploymentStatus.parttime => BadgeTone.success,
          EmploymentStatus.internship => BadgeTone.warning,
          EmploymentStatus.freelance => BadgeTone.danger,
        },
      ),
    ),
    DataColumnDef(
      label: 'Skill',
      flex: 3,
      cell: (_, m) => Text(m.skills.isEmpty ? '-' : m.skills.join(', ')),
    ),
    DataColumnDef(label: 'Position', flex: 2, cell: (_, m) => Text(m.position)),
    DataColumnDef(label: 'Phone Number', flex: 2, cell: (_, m) => Text(m.phoneNumber)),
    DataColumnDef(label: 'Email', flex: 3, cell: (_, m) => Text(m.email)),
    DataColumnDef(
      label: 'Action',
      flex: 2,
      isAction: true,
      cell: (_, m) => Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(onPressed: () {}, icon: const Icon(Iconsax.eye, size: 20), color: AppColors.primary),
        IconButton(onPressed: () {}, icon: const Icon(Iconsax.edit_2, size: 20), color: AppColors.orange),
        IconButton(onPressed: () {}, icon: const Icon(Iconsax.trash, size: 20), color: AppColors.danger),
      ]),
    ),
  ];
}

class _Toolbar extends ConsumerWidget {
  const _Toolbar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(manpowerStatusFilterProvider);

    final search = TextField(
      onChanged: (v) => ref.read(manpowerSearchProvider.notifier).state = v,
      decoration: const InputDecoration(
        hintText: 'Search employee...',
        prefixIcon: Icon(Iconsax.search_normal, size: 18),
      ),
    );

    final filter = DropdownButtonFormField<EmploymentStatus?>(
      initialValue: status,
      isExpanded: true,
      decoration: const InputDecoration(prefixIcon: Icon(Iconsax.filter, size: 18)),
      hint: const Text('All Status'),
      items: [
        const DropdownMenuItem(value: null, child: Text('All Status')),
        for (final s in EmploymentStatus.values)
          DropdownMenuItem(value: s, child: Text(s.label)),
      ],
      onChanged: (v) => ref.read(manpowerStatusFilterProvider.notifier).state = v,
    );

    final add = FilledButton.icon(
      onPressed: () {},
      icon: const Icon(Iconsax.add, size: 18),
      label: const Text('Add Employee'),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stroke),
      ),
      child: context.isMobile
          ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              search,
              const SizedBox(height: 12),
              filter,
              const SizedBox(height: 12),
              add,
            ])
          : Row(children: [
              Expanded(flex: 3, child: search),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: filter),
              const SizedBox(width: 12),
              add,
            ]),
    );
  }
}
