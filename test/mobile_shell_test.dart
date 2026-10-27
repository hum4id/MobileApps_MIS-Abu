import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mis_app/app/app.dart';
import 'package:mis_app/core/widgets/mobile_nav_bar.dart';

void main() {
  // Pastikan mobile shell (AppBar + bottom nav) render tanpa overflow di
  // lebar ponsel umum, termasuk perangkat kecil 320px.
  for (final size in const [Size(320, 640), Size(360, 740), Size(412, 870)]) {
    testWidgets('mobile shell renders without overflow @ ${size.width}', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const ProviderScope(child: MisApp()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(MobileNavBar), findsOneWidget); // bottom bar hadir
    });
  }
}
