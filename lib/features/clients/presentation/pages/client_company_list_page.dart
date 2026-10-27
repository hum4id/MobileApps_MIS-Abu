import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/data_toolbar.dart';
import '../../../../core/widgets/responsive_data_view.dart';
import '../../domain/entities/client.dart';
import '../providers/client_providers.dart';

class ClientCompanyListPage extends ConsumerWidget {
  const ClientCompanyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies = ref.watch(clientCompanyListProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!context.isMobile) ...[
            Text('Data Company', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
          ],
          DataToolbar(
            searchHint: 'Search company...',
            onSearch: (v) => ref.read(clientCompanySearchProvider.notifier).state = v,
            action: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Iconsax.add, size: 18),
              label: const Text('Add Company'),
            ),
          ),
          const SizedBox(height: 16),
          companies.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Gagal memuat data: $e'),
            data: (items) => ResponsiveDataView<ClientCompany>(
              items: items,
              columns: _columns,
              emptyMessage: 'Tidak ada company ditemukan.',
              footer: Text('Showing ${items.length} data out of ${items.length}',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
        ],
      ),
    );
  }

  static final _columns = <DataColumnDef<ClientCompany>>[
    DataColumnDef(
      label: 'Company Name',
      flex: 3,
      isTitle: true,
      cell: (_, c) => Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
    ),
    DataColumnDef(label: 'Code', flex: 2, cell: (_, c) => Text(c.code)),
    DataColumnDef(label: 'City', flex: 2, cell: (_, c) => Text(c.city)),
    DataColumnDef(label: 'Email', flex: 3, cell: (_, c) => Text(c.email)),
    DataColumnDef(label: 'Phone', flex: 2, cell: (_, c) => Text(c.phone)),
    DataColumnDef(
      label: 'Action',
      flex: 2,
      isAction: true,
      cell: (_, c) => Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(onPressed: () {}, icon: const Icon(Iconsax.eye, size: 20), color: AppColors.primary),
        IconButton(onPressed: () {}, icon: const Icon(Iconsax.edit_2, size: 20), color: AppColors.orange),
        IconButton(onPressed: () {}, icon: const Icon(Iconsax.trash, size: 20), color: AppColors.danger),
      ]),
    ),
  ];
}
