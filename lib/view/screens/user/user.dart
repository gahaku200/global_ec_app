// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../services/utils.dart';
import '../../../view_model/dark_theme_provider.dart';
import '../../../view_model/user_provider.dart';
import 'user_widget.dart';

class UserScreen extends HookConsumerWidget {
  UserScreen({super.key});

  final isLoadingProvider = StateProvider((ref) => false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final isDark = ref.watch(themeState);
    final isLoading = ref.watch(isLoadingProvider);
    final isLoadingNotifier = ref.read(isLoadingProvider.notifier);
    final user = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          isLoadingNotifier.state = true;
          await userNotifier.getUserData(context);
          isLoadingNotifier.state = false;
        });
        return;
      },
      [],
    );

    return UserWidget(
      isLoading: isLoading,
      userName: user.name,
      color: color,
      isDark: isDark,
    );
  }
}
