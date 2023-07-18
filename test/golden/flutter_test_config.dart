// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      defaultDevices: const [
        Device(
          name: 'mobileS', // 最小の端末
          size: Size(360, 720),
          devicePixelRatio: 3,
          safeArea: EdgeInsets.only(top: 44, bottom: 34),
        ),
        Device(
          name: 'mobileM',
          size: Size(390, 844),
          devicePixelRatio: 3,
          safeArea: EdgeInsets.only(top: 44, bottom: 34),
        ),
        Device(
          name: 'mobileL', // 最大の端末
          size: Size(428, 926),
          devicePixelRatio: 3,
          safeArea: EdgeInsets.only(top: 44, bottom: 34),
        ),
      ],

      // Currently, goldens are not generated/validated in CI for this repo. We have settled on the goldens for this package
      // being captured/validated by developers running on MacOSX. We may revisit this in the future if there is a reason to invest
      // in more sophistication
      skipGoldenAssertion: () => !Platform.isMacOS,
    ),
  );
}
