import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mis_app/core/theme/app_theme.dart';
import 'package:mis_app/features/manpower/presentation/pages/manpower_list_page.dart';

void main() {
  Widget harness(Size size) => ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: MediaQueryData(size: size),
            child: const Scaffold(body: ManpowerListPage()),
          ),
        ),
      );

  testWidgets('menampilkan karyawan sebagai kartu di mobile tanpa overflow',
      (tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(harness(const Size(360, 740)));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Agus T.'), findsOneWidget);
    expect(find.text('Fulltime'), findsWidgets);
  });
}
