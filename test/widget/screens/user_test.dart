// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:global_ec_app/consts/theme_data.dart';
import 'package:global_ec_app/view/screens/user.dart';
import 'package:global_ec_app/view_model/dark_theme_provider.dart';
import 'package:global_ec_app/view_model/user_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  setUpAll(() async {
    // Firebaseの初期化
    await Firebase.initializeApp();
  });
  group('user画面Widgetテスト', () {
    testWidgets('ログイン前後のテスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: UserScreen()),
        ),
      );

      // ログイン前のテスト
      // widgetテスト
      final firstRichText = find.byType(RichText).first;
      expect(
        tester.widget<RichText>(firstRichText).text.toPlainText(),
        'User:  Guest not logged in',
      );
      expect(find.byType(ListTile), findsNWidgets(3));
      expect(find.byType(SwitchListTile), findsOneWidget);
      // iconテスト
      expect(find.byIcon(IconlyLight.bag), findsNothing);
      expect(find.byIcon(IconlyLight.show), findsOneWidget);
      expect(find.byIcon(IconlyLight.heart), findsNothing);
      expect(find.byIcon(IconlyLight.profile), findsNothing);
      expect(find.byIcon(IconlyLight.unlock), findsNothing);
      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode_outlined), findsNothing);
      expect(find.byIcon(IconlyLight.login), findsOneWidget);
      expect(find.byIcon(IconlyLight.logout), findsNothing);

      // userに名前を付与することでログイン状態と仮定する
      // BuildContextを取得
      final BuildContext context = tester.element(
        find.byWidgetPredicate((Widget widget) => widget is UserScreen),
      );
      // ProviderContainerを取得
      final container = ProviderScope.containerOf(context);
      // ProviderContainerからproviderをreadしてsetNameを呼び出し
      await container.read(userProvider.notifier).setName('John Doe');

      // widget再描画
      await tester.pump();

      // ログイン後のテスト
      // widgetテスト
      final firstRichTextLogin = find.byType(RichText).first;
      expect(
        tester.widget<RichText>(firstRichTextLogin).text.toPlainText(),
        'User:  John Doe',
      );
      expect(find.byType(ListTile), findsNWidgets(7));
      expect(find.byType(SwitchListTile), findsOneWidget);
      // iconテスト
      expect(find.byIcon(IconlyLight.bag), findsOneWidget);
      expect(find.byIcon(IconlyLight.show), findsOneWidget);
      expect(find.byIcon(IconlyLight.heart), findsOneWidget);
      expect(find.byIcon(IconlyLight.profile), findsOneWidget);
      expect(find.byIcon(IconlyLight.unlock), findsOneWidget);
      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode_outlined), findsNothing);
      expect(find.byIcon(IconlyLight.login), findsNothing);
      expect(find.byIcon(IconlyLight.logout), findsOneWidget);
    });

    testWidgets('Themeスイッチのテスト', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: Consumer(
            builder: (BuildContext context, ref, child) {
              final value = ref.watch(themeState);
              return FutureBuilder(
                future: ref.watch(themeState.notifier).initialState(),
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  return MaterialApp(
                    theme: Styles.themeData(value, context),
                    home: UserScreen(),
                  );
                },
              );
            },
          ),
        ),
      );

      // widgetテスト
      expect(find.byType(SwitchListTile), findsOneWidget);
      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode_outlined), findsNothing);

      // MaterialApp widgetを探して、その背景色を取得する
      var materialApp =
          find.byType(MaterialApp).evaluate().first.widget as MaterialApp;
      var backgroundColor = materialApp.theme?.scaffoldBackgroundColor;
      // 初期状態ではライトモードになっていることを確認する
      expect(backgroundColor, equals(lightThemeData.scaffoldBackgroundColor));

      // SwitchListTileをタップする
      await tester.tap(find.byType(SwitchListTile));
      // アイコンが更新されるため再描画が必要
      await tester.pump();

      // アイコンが更新され、アイコンはダークモードが表示されることを確認する
      expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
      expect(find.byIcon(Icons.light_mode_outlined), findsNothing);

      // 再度MaterialApp widgetを探して、その背景色を取得する
      materialApp =
          find.byType(MaterialApp).evaluate().first.widget as MaterialApp;
      backgroundColor = materialApp.theme?.scaffoldBackgroundColor;
      // ダークモードになっていることを確認する
      expect(backgroundColor, equals(darkThemeData.scaffoldBackgroundColor));

      // SwitchListTileをタップする
      await tester.tap(find.byType(SwitchListTile));
      // アイコンが更新されるため再描画が必要
      await tester.pump();

      // アイコンが更新され、アイコンはライトモードが表示されることを確認する
      expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode_outlined), findsNothing);

      // 再度MaterialApp widgetを探して、その背景色を取得する
      materialApp =
          find.byType(MaterialApp).evaluate().first.widget as MaterialApp;
      backgroundColor = materialApp.theme?.scaffoldBackgroundColor;
      // ライトモードになっていることを確認する
      expect(backgroundColor, equals(lightThemeData.scaffoldBackgroundColor));
    });
  });
}

// ライトモードのプロパティ
final lightThemeData = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  colorScheme: ThemeData().colorScheme.copyWith(
        secondary: const Color(0xFFE8FDFD),
        brightness: Brightness.light,
      ),
  cardColor: const Color(0xFFF2FDFD),
  canvasColor: Colors.grey[50],
);

// ダークモードのプロパティ
final darkThemeData = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF00001a),
  colorScheme: ThemeData().colorScheme.copyWith(
        secondary: const Color(0xFF1a1f3c),
        brightness: Brightness.dark,
      ),
  cardColor: const Color(0xFF0a0d2c),
  canvasColor: Colors.black.withOpacity(0.85),
);
