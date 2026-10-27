import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/data_toolbar.dart';
import '../../../../core/widgets/responsive_data_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/skill.dart';
import '../providers/skill_providers.dart';

class SkillListPage extends ConsumerWidget {
  const SkillListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skills = ref.watch(skillListProvider);
    final status = ref.watch(skillStatusFilterProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!context.isMobile) ...[
            Text('Skill Management', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
          ],
          DataToolbar(
            searchHint: 'Search skill...',
            onSearch: (v) => ref.read(skillSearchProvider.notifier).state = v,
            filter: DropdownButtonFormField<SkillStatus?>(
              initialValue: status,
              isExpanded: true,
              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.filter, size: 18)),
              hint: const Text('All Status'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Status')),
                for (final s in SkillStatus.values)
                  DropdownMenuItem(value: s, child: Text(s.label)),
              ],
              onChanged: (v) => ref.read(skillStatusFilterProvider.notifier).state = v,
            ),
            action: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Iconsax.add, size: 18),
              label: const Text('Add Skill'),
            ),
          ),
          const SizedBox(height: 16),
          skills.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Gagal memuat data: $e'),
            data: (items) => ResponsiveDataView<Skill>(
              items: items,
              columns: _columns,
              emptyMessage: 'Tidak ada skill ditemukan.',
              footer: Text('Showing ${items.length} data out of ${items.length}',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
        ],
      ),
    );
  }

  static final _columns = <DataColumnDef<Skill>>[
    DataColumnDef(
      label: 'Skill Name',
      flex: 3,
      isTitle: true,
      cell: (_, s) => Text(s.name, style: const TextStyle(fontWeight: FontWeight.w600)),
    ),
    DataColumnDef(label: 'Category', flex: 2, cell: (_, s) => Text(s.category)),
    DataColumnDef(label: 'Used By', flex: 1, cell: (_, s) => Text('${s.usedBy} employee')),
    DataColumnDef(
      label: 'Status',
      flex: 2,
      cell: (_, s) => StatusBadge(
        label: s.status.label,
        tone: s.status == SkillStatus.active ? BadgeTone.success : BadgeTone.neutral,
      ),
    ),
    DataColumnDef(
      label: 'Action',
      flex: 2,
      isAction: true,
      cell: (_, s) => Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(onPressed: () {}, icon: const Icon(Iconsax.edit_2, size: 20), color: AppColors.orange),
        IconButton(onPressed: () {}, icon: const Icon(Iconsax.trash, size: 20), color: AppColors.danger),
      ]),
    ),
  ];
}
