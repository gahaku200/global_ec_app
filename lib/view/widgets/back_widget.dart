// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../services/utils.dart';

class BackWidget extends HookConsumerWidget {
  const BackWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        context.go('/BottomBarScreen');
      },
      child: Icon(
        IconlyLight.arrowLeft2,
        color: color,
      ),
    );
  }
}
