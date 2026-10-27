import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mis_app/core/theme/app_theme.dart';
import 'package:mis_app/features/approvals/presentation/pages/approval_list_page.dart';
import 'package:mis_app/features/clients/presentation/pages/client_company_list_page.dart';
import 'package:mis_app/features/clients/presentation/pages/client_pic_list_page.dart';
import 'package:mis_app/features/profile/presentation/pages/profile_page.dart';
import 'package:mis_app/features/projects/presentation/pages/history_project_page.dart';
import 'package:mis_app/features/skills/presentation/pages/skill_list_page.dart';

void main() {
  final pages = <String, Widget>{
    'Approval': const ApprovalListPage(),
    'History': const HistoryProjectPage(),
    'Skills': const SkillListPage(),
    'Client PIC': const ClientPicListPage(),
    'Client Company': const ClientCompanyListPage(),
    'Profile': const ProfilePage(),
  };

  pages.forEach((name, page) {
    testWidgets('$name renders at mobile width without overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.light,
            home: MediaQuery(
              data: const MediaQueryData(size: Size(360, 780)),
              child: Scaffold(body: page),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: '$name overflowed or threw');
    });
  });
}
