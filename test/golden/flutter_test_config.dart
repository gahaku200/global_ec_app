// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:global_ec_app/consts/theme_data.dart';
import 'package:global_ec_app/view_model/dark_theme_provider.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      defaultDevices: const [
        // 縦向き
        Device(
          name: 'mobileS vertical', // 最小の端末
          size: Size(360, 720),
          devicePixelRatio: 3,
          safeArea: EdgeInsets.only(top: 44, bottom: 34),
        ),
        Device(
          name: 'mobileM vertical',
          size: Size(390, 844),
          devicePixelRatio: 3,
          safeArea: EdgeInsets.only(top: 44, bottom: 34),
        ),
        Device(
          name: 'mobileL vertical', // 最大の端末
          size: Size(428, 926),
          devicePixelRatio: 3,
          safeArea: EdgeInsets.only(top: 44, bottom: 34),
        ),

        // 横向き
        Device(
          name: 'mobileS horizontal', // 最小の端末
          size: Size(720, 360),
          devicePixelRatio: 3,
          safeArea: EdgeInsets.only(top: 44, bottom: 34),
        ),
        Device(
          name: 'mobileM horizontal',
          size: Size(844, 390),
          devicePixelRatio: 3,
          safeArea: EdgeInsets.only(top: 44, bottom: 34),
        ),
        Device(
          name: 'mobileL horizontal', // 最大の端末
          size: Size(926, 428),
          devicePixelRatio: 3,
          safeArea: EdgeInsets.only(top: 44, bottom: 34),
        ),
      ],

      // Currently, goldens are not generated/validated in CI for this repo. We have settled on the goldens for this package
      // being captured/validated by developers running on MacOSX. We may revisit this in the future if there is a reason to invest
      // in more sophistication
      skipGoldenAssertion: () => !Platform.isMacOS,
      enableRealShadows: true,
    ),
  );
}

Widget pageWrapper(Widget widget) {
  return ProviderScope(
    child: MaterialApp(
      // ThemeやfontoFamiliyの指定はココで
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Murecho',
      ),
      home: widget,
    ),
  );
}

Widget pageWrapperDarkMode(Widget widget) {
  return ProviderScope(
    overrides: [
      themeState.overrideWith(
        (ref) {
          return DarkThemeProvider()..isDarkTheme = true;
        },
      ),
    ],
    child: Consumer(
      builder: (BuildContext context, ref, child) {
        return FutureBuilder(
          future: ref.watch(themeState.notifier).initialState(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: Styles.themeData(true, context),
              home: widget,
            );
          },
        );
      },
    ),
  );
}
