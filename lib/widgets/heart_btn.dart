// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_method.dart';
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
        final user = authInstance.currentUser;
        if (user == null) {
          GlobalMethods.errorDialog(
            subtitle: 'No user found, Please login first',
            context: context,
          );
          return;
        }
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
