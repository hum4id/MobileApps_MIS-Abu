import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/status_badge.dart';

class _Stat {
  const _Stat(this.label, this.value, this.icon, this.color);
  final String label;
  final int value;
  final IconData icon;
  final Color color;
}

class _Schedule {
  const _Schedule(this.name, this.client, this.date, this.tone, this.status);
  final String name;
  final String client;
  final DateTime date;
  final BadgeTone tone;
  final String status;
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Angka contoh dari Figma. Ganti dengan provider data asli.
    const stats = <_Stat>[
      _Stat('Total Contract Value', 19000000, Iconsax.wallet_money, AppColors.primary),
      _Stat('Total Paid', 5000000, Iconsax.money_recive, AppColors.success),
      _Stat('Rest of the Bill', 14000000, Iconsax.money_send, AppColors.orange),
      _Stat('Total Project Cost', 8000000, Iconsax.chart_2, AppColors.navy),
    ];

    final schedules = <_Schedule>[
      _Schedule('Annual Summit Livestream', 'PT Nusantara', DateTime(2026, 5, 21), BadgeTone.info, 'New'),
      _Schedule('The Onsen Resort Wedding', 'Onsen Group', DateTime(2026, 7, 10), BadgeTone.progress, 'On progress'),
      _Schedule('CV Berkah Abadi Corporate', 'CV Berkah', DateTime(2026, 8, 15), BadgeTone.info, 'New'),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Selamat datang', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text("Here's what's happening with your projects today.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          LayoutBuilder(builder: (context, c) {
            // 4 kolom (desktop) -> 2 kolom (tablet/mobile). Kartu ringkas 2-up
            // di ponsel: ringkas, tidak perlu scroll panjang.
            final cols = c.maxWidth >= 900 ? 4 : 2;
            const gap = 12.0;
            final w = (c.maxWidth - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [for (final s in stats) SizedBox(width: w, child: _StatCard(stat: s))],
            );
          }),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: Text('Upcoming Schedule',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              TextButton(onPressed: () {}, child: const Text('See all')),
            ],
          ),
          const SizedBox(height: 4),
          for (final s in schedules) _ScheduleTile(schedule: s),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});
  final _Stat stat;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: stat.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(stat.icon, size: 20, color: stat.color),
            ),
            const SizedBox(height: 12),
            Text(stat.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(Formatters.rupiah(stat.value),
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile({required this.schedule});
  final _Schedule schedule;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Iconsax.calendar_1, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(schedule.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text('${schedule.client} · ${Formatters.date(schedule.date)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              StatusBadge(label: schedule.status, tone: schedule.tone),
            ],
          ),
        ),
      ),
    );
  }
}
