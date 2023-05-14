// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../services/utils.dart';

class EmptyProdWidget extends HookConsumerWidget {
  const EmptyProdWidget({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(18),
            //   child: Image.asset(
            //     'assets/images/box.png',
            //   ),
            // ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
