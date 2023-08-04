// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

// Project imports:
import 'package:global_ec_app/view/screens/user/user_widget.dart';
import '../flutter_test_config.dart';

void main() {
  group('user画面ゴールデンテスト', () {
    testGoldens('ログイン前ライトモード', (WidgetTester tester) async {
      final builder = DeviceBuilder()
        ..addScenario(
          widget: pageWrapper(
            UserWidget(
              isLoading: false,
              userName: '',
              color: Colors.black.withOpacity(0.85),
              isDark: false,
            ),
          ),
          name: 'UserWidgetBeforeLoginLightMode',
        );
      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'user_widget_before_login_light_mode');
    });
    testGoldens('ログイン後ライトモード', (WidgetTester tester) async {
      final builder = DeviceBuilder()
        ..addScenario(
          widget: pageWrapper(
            UserWidget(
              isLoading: false,
              userName: 'Bob',
              color: Colors.black.withOpacity(0.85),
              isDark: false,
            ),
          ),
          name: 'UserWidgetAfterLoginLightMode',
        );
      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'user_widget_after_login_light_mode');
    });
    testGoldens('ログイン前ダークモード', (WidgetTester tester) async {
      final builder = DeviceBuilder()
        ..addScenario(
          widget: pageWrapperDarkMode(
            UserWidget(
              isLoading: false,
              userName: '',
              color: Colors.white.withOpacity(0.9),
              isDark: true,
            ),
          ),
          name: 'UserWidgetBeforeLoginDarkMode',
        );
      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'user_widget_before_login_dark_mode');
    });
    testGoldens('ログイン後ダークモード', (WidgetTester tester) async {
      final builder = DeviceBuilder()
        ..addScenario(
          widget: pageWrapperDarkMode(
            UserWidget(
              isLoading: false,
              userName: 'Bob',
              color: Colors.white.withOpacity(0.9),
              isDark: true,
            ),
          ),
          name: 'UserWidgetAfterLoginDarkMode',
        );
      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'user_widget_after_login_dark_mode');
    });
  });
}
