// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../consts/firebase_consts.dart';
import '../../../model/wishlist/wishlist_model.dart';
import '../../../services/global_method.dart';
import '../../../services/utils.dart';
import '../../../view_model/cart_provider.dart';
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
    final carts = ref.watch(cartProvider);
    final isInCart = carts.containsKey(currentProduct.id);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {
          context.go('/ProductDetails/${currentProduct.id}');
        },
        child: Container(
          height: size.height * 0.2,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  // width: size.width * 0.2,
                  height: size.width * 0.25,
                  child: FancyShimmerImage(
                    imageUrl: currentProduct.imageUrl,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: isInCart
                                ? null
                                : () {
                                    final user = authInstance.currentUser;
                                    if (user == null) {
                                      GlobalMethods.errorDialog(
                                        subtitle:
                                            'No user found, Please login first',
                                        context: context,
                                      );
                                      return;
                                    }
                                    GlobalMethods.addToCart(
                                      productId: currentProduct.id,
                                      quantity: 1,
                                      context: context,
                                    );
                                    ref.read(cartProvider.notifier).fetchCart();
                                  },
                            icon: Icon(
                              isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                              color: isInCart ? Colors.green : color,
                            ),
                          ),
                          HeartBTN(
                            productId: currentProduct.id,
                            isInWishlist: isInWishlist,
                          ),
                        ],
                      ),
                    ),
                    TextWidget(
                      text: currentProduct.title,
                      color: color,
                      textSize: 20,
                      maxLines: 2,
                      isTitle: true,
                    ),
                    const SizedBox(height: 5),
                    TextWidget(
                      text: '\$${usedPrice.toStringAsFixed(2)}',
                      color: color,
                      textSize: 18,
                      maxLines: 1,
                      isTitle: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
