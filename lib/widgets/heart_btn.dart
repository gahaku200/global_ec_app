// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../providers/wishlist_provider.dart';
import '../services/utils.dart';

class HeartBTN extends HookConsumerWidget {
  const HeartBTN({
    super.key,
    required this.productId,
    this.isInWishlist = false,
  });

  final String productId;
  final bool isInWishlist;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);

    return GestureDetector(
      onTap: () {
        ref.read(wishlistProvider.notifier).addRemoveProductToWishlist(
              productId: productId,
            );
      },
      child: Icon(
        isInWishlist ? IconlyBold.heart : IconlyLight.heart,
        size: 22,
        color: isInWishlist ? Colors.red : color,
      ),
    );
  }
}
