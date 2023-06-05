// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../consts/firebase_consts.dart';
import '../../services/global_method.dart';
import '../../services/utils.dart';
import '../../view_model/products_provider.dart';
import '../../view_model/wishlist_provider.dart';

final loadingProvider = StateProvider((_) => false);

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
    final getCurrProduct =
        ref.read(productsProvider.notifier).findProdById(productId);
    final loading = ref.watch(loadingProvider);

    return GestureDetector(
      onTap: () async {
        ref.read(loadingProvider.notifier).state = true;
        try {
          final user = authInstance.currentUser;
          if (user == null) {
            await GlobalMethods.errorDialog(
              subtitle: 'No user found, Please login first',
              context: context,
            );
            ref.read(loadingProvider.notifier).state = false;
            return;
          }

          if (isInWishlist == false) {
            await GlobalMethods.addToWishlist(
              productId: productId,
              context: context,
            );
          } else {
            await ref.read(wishlistProvider.notifier).removeOneItem(
                  wishlistId: ref
                      .read(wishlistProvider.notifier)
                      .getWishlistItems[getCurrProduct.id]!
                      .id,
                  productId: productId,
                );
          }
          ref.read(loadingProvider.notifier).state = false;
          await ref.read(wishlistProvider.notifier).fetchWishlist();
          // ignore: avoid_catches_without_on_clauses
        } catch (error) {
          await GlobalMethods.errorDialog(subtitle: '$error', context: context);
        } finally {
          if (loading) {
            ref.read(loadingProvider.notifier).state = false;
          }
        }
      },
      child: loading
          ? const Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(),
              ),
            )
          : Icon(
              isInWishlist ? Icons.favorite : Icons.favorite_border_outlined,
              size: 22,
              color: isInWishlist ? Colors.red : color,
            ),
    );
  }
}
