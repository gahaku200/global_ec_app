// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../services/utils.dart';
import '../../widgets/text_widget.dart';

class OrderWidget extends HookConsumerWidget {
  const OrderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;

    return ListTile(
      subtitle: const Text('Paid: \$12.8'),
      onTap: () {
        context.go('/ProductDetails');
      },
      leading: FancyShimmerImage(
        width: size.width * 0.2,
        imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricots.png',
      ),
      title: TextWidget(
        text: 'Title x12',
        color: color,
        textSize: 18,
      ),
      trailing: TextWidget(
        text: '03/08/2022',
        color: color,
        textSize: 18,
      ),
    );
  }
}
