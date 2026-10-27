import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';

/// Profil pengguna yang sedang login. Data contoh dari mock web
/// (lib/mock/users.mock.ts -> getProfile).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _name = 'John Doe';
  static const _position = 'Director';
  static const _email = 'john@makromedia.com';
  static const _phone = '081234567890';
  static const _address = 'Surabaya, East Java';
  static const _skills = ['Leadership', 'Management', 'Strategic Planning', 'Project Management'];
  static const _bankName = 'Bank Central Asia';
  static const _accountNumber = '7265189474';
  static const _accountHolder = 'John Doe';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.pagePadding),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(name: _name, position: _position),
              const SizedBox(height: 16),
              const _Section(
                title: 'Personal Information',
                children: [
                  _InfoRow(icon: Iconsax.sms, label: 'Email', value: _email),
                  _InfoRow(icon: Iconsax.call, label: 'Phone', value: _phone),
                  _InfoRow(icon: Iconsax.location, label: 'Address', value: _address),
                ],
              ),
              const SizedBox(height: 16),
              _Section(
                title: 'Skills',
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final s in _skills)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary50,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(s,
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500)),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _Section(
                title: 'Bank Account',
                children: [
                  _InfoRow(icon: Iconsax.bank, label: 'Bank', value: _bankName),
                  _InfoRow(icon: Iconsax.card, label: 'Account Number', value: _accountNumber),
                  _InfoRow(icon: Iconsax.user, label: 'Account Holder', value: _accountHolder),
                ],
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => context.go(AppRoutes.login),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.dangerLight),
                ),
                icon: const Icon(Iconsax.logout, size: 18),
                label: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.position});
  final String name;
  final String position;

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? '?'
        : name.trim().split(RegExp(r'\s+')).take(2).map((w) => w[0]).join().toUpperCase();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.white,
            child: Text(initials,
                style: const TextStyle(
                    color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(position,
                    style: TextStyle(color: AppColors.white.withValues(alpha: 0.85), fontSize: 14)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.edit, color: AppColors.white),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.gray500),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
