// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../model/wishlist/wishlist_model.dart';
import '../../../services/utils.dart';
import '../../../view_model/products_provider.dart';
import '../../../view_model/wishlist_provider.dart';
import '../../widgets/heart_btn.dart';
import '../../widgets/text_widget.dart';

class WishlistWidget extends HookConsumerWidget {
  const WishlistWidget({
    super.key,
    required this.wishlistModel,
  });

  final WishlistModel wishlistModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;
    final currentProduct = ref
        .read(productsProvider.notifier)
        .findProdById(wishlistModel.productId);
    final usedPrice = currentProduct.isOnSale
        ? currentProduct.salePrice
        : currentProduct.price;
    final wishlist = ref.watch(wishlistProvider);
    final isInWishlist = wishlist.containsKey(currentProduct.id);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () {
          context.go('/ProductDetails/${currentProduct.id}');
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FancyShimmerImage(
                imageUrl: currentProduct.imageUrlList[0],
                height: size.width * 0.22,
                width: size.width * 0.3,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              children: [
                TextWidget(
                  text: currentProduct.title,
                  color: color,
                  textSize: 20,
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    TextWidget(
                      text: '\$${usedPrice.toStringAsFixed(2)}',
                      color: Colors.red.shade300,
                      textSize: 17,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Visibility(
                      // ignore: avoid_bool_literals_in_conditional_expressions
                      visible: currentProduct.isOnSale ? true : false,
                      child: Text(
                        '\$${currentProduct.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          color: color,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            HeartBTN(
              productId: currentProduct.id,
              isInWishlist: isInWishlist,
            ),
          ],
        ),
      ),
    );
  }
}
