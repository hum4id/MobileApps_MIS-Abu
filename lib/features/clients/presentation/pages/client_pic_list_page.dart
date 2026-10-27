import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/data_toolbar.dart';
import '../../../../core/widgets/responsive_data_view.dart';
import '../../domain/entities/client.dart';
import '../providers/client_providers.dart';

class ClientPicListPage extends ConsumerWidget {
  const ClientPicListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pics = ref.watch(clientPicListProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!context.isMobile) ...[
            Text('Data Client', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
          ],
          DataToolbar(
            searchHint: 'Search client...',
            onSearch: (v) => ref.read(clientPicSearchProvider.notifier).state = v,
            action: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Iconsax.add, size: 18),
              label: const Text('Add Client'),
            ),
          ),
          const SizedBox(height: 16),
          pics.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Gagal memuat data: $e'),
            data: (items) => ResponsiveDataView<ClientPic>(
              items: items,
              columns: _columns,
              emptyMessage: 'Tidak ada client ditemukan.',
              footer: Text('Showing ${items.length} data out of ${items.length}',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
        ],
      ),
    );
  }

  static final _columns = <DataColumnDef<ClientPic>>[
    DataColumnDef(
      label: 'Name',
      flex: 2,
      isTitle: true,
      cell: (_, c) => Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
    ),
    DataColumnDef(label: 'Company', flex: 3, cell: (_, c) => Text(c.company)),
    DataColumnDef(label: 'Position', flex: 2, cell: (_, c) => Text(c.position)),
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
