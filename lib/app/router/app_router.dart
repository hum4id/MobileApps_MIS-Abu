import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/app_shell.dart';
import '../../features/approvals/presentation/pages/approval_list_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/clients/presentation/pages/client_company_list_page.dart';
import '../../features/clients/presentation/pages/client_pic_list_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/manpower/presentation/pages/manpower_list_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/projects/presentation/pages/history_project_page.dart';
import '../../features/projects/presentation/pages/project_list_page.dart';
import '../../features/skills/presentation/pages/skill_list_page.dart';

/// Semua path aplikasi di satu tempat (dipakai juga oleh sidebar).
abstract final class AppRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const approvals = '/approvals';
  static const projects = '/projects';
  static const history = '/history';
  static const manpower = '/manpower';
  static const skills = '/skills';
  static const clients = '/clients';
  static const companies = '/companies';
  static const profile = '/profile';
}

final routerProvider = Provider<GoRouter>((ref) {
  // TODO: ganti dengan state auth (Riverpod) + redirect guard.
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          _shellRoute(AppRoutes.dashboard, const DashboardPage()),
          _shellRoute(AppRoutes.projects, const ProjectListPage()),
          _shellRoute(AppRoutes.history, const HistoryProjectPage()),
          _shellRoute(AppRoutes.approvals, const ApprovalListPage()),
          _shellRoute(AppRoutes.manpower, const ManpowerListPage()),
          _shellRoute(AppRoutes.skills, const SkillListPage()),
          _shellRoute(AppRoutes.clients, const ClientPicListPage()),
          _shellRoute(AppRoutes.companies, const ClientCompanyListPage()),
          _shellRoute(AppRoutes.profile, const ProfilePage()),
        ],
      ),
    ],
  );
});

/// Helper: rute di dalam shell tanpa animasi transisi (terasa seperti tab).
GoRoute _shellRoute(String path, Widget child) => GoRoute(
      path: path,
      pageBuilder: (_, __) => NoTransitionPage(child: child),
    );
