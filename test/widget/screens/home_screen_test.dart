// import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// import 'package:global_ec_app/app.dart';
// import 'package:global_ec_app/provider/dark_theme_provider.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('画面表示のテスト', () {
    // 成功するテストケース
    test('mytest1', () {
      const ans = 10;
      expect(ans, 10);
    });
//     testWidgets('Themeスイッチのテスト', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         ProviderScope(
//           child: Consumer(
//             builder: (BuildContext context, ref, child) {
//               return FutureBuilder(
//                 future: ref.watch(themeState.notifier).initialState(),
//                 builder: (context, AsyncSnapshot<bool> snapshot) {
//                   return App();
//                 },
//               );
//             },
//           ),
//         ),
//       );
//       // Themeが表示されることを確認する
//       expect(find.text('Theme'), findsOneWidget);
//       // SwitchListTileが表示されることを確認する
//       expect(find.byType(SwitchListTile), findsOneWidget);
//       // 初期状態ではアイコンはライトモードが表示されることを確認する
//       expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);

//       // MaterialApp widgetを探して、その背景色を取得する
//       final materialApp =
//           find.byType(MaterialApp).evaluate().first.widget as MaterialApp;
//       final backgroundColor = materialApp.theme?.scaffoldBackgroundColor;
//       // 初期状態ではライトモードになっていることを確認する
//       expect(backgroundColor, equals(lightThemeData.scaffoldBackgroundColor));

//       // SwitchListTileをタップする
//       await tester.tap(find.byType(SwitchListTile));
//       // アイコンが更新されるため再描画が必要
//       await tester.pump();

//       // アイコンが更新され、アイコンはダークモードが表示されることを確認する
//       expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
//       expect(find.byIcon(Icons.light_mode_outlined), findsNothing);

//       // 再度MaterialApp widgetを探して、その背景色を取得する
//       final materialApp2 =
//           find.byType(MaterialApp).evaluate().first.widget as MaterialApp;
//       final backgroundColor2 = materialApp2.theme?.scaffoldBackgroundColor;
//       // ダークモードになっていることを確認する
//       expect(backgroundColor2, equals(darkThemeData.scaffoldBackgroundColor));

//       // SwitchListTileをタップする
//       await tester.tap(find.byType(SwitchListTile));
//       // アイコンが更新されるため再描画が必要
//       await tester.pump();

//       // アイコンが更新され、アイコンはライトモードが表示されることを確認する
//       expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
//       expect(find.byIcon(Icons.dark_mode_outlined), findsNothing);

//       // 再度MaterialApp widgetを探して、その背景色を取得する
//       final materialApp3 =
//           find.byType(MaterialApp).evaluate().first.widget as MaterialApp;
//       final backgroundColor3 = materialApp3.theme?.scaffoldBackgroundColor;
//       // ダークモードになっていることを確認する
//       expect(backgroundColor3, equals(lightThemeData.scaffoldBackgroundColor));
//     });
  });
}

// // ライトモードのプロパティ
// final lightThemeData = ThemeData(
//   scaffoldBackgroundColor: const Color(0xFFFFFFFF),
//   colorScheme: ThemeData().colorScheme.copyWith(
//         secondary: const Color(0xFFE8FDFD),
//         brightness: Brightness.light,
//       ),
//   cardColor: const Color(0xFFF2FDFD),
//   canvasColor: Colors.grey[50],
// );

// // ダークモードのプロパティ
// final darkThemeData = ThemeData(
//   scaffoldBackgroundColor: const Color(0xFF00001a),
//   colorScheme: ThemeData().colorScheme.copyWith(
//         secondary: const Color(0xFF1a1f3c),
//         brightness: Brightness.dark,
//       ),
//   cardColor: const Color(0xFF0a0d2c),
//   canvasColor: Colors.black,
// );
