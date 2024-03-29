// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../view_model/dark_theme_provider.dart';

class Utils {
  Utils(this.context);
  BuildContext context;

  final getTheme = Provider((ref) {
    final isDark = ref.watch(themeState);
    return isDark
        ? Colors.white.withOpacity(0.9)
        : Colors.black.withOpacity(0.85);
  });

  Size get getScreenSize => MediaQuery.of(context).size;
}
