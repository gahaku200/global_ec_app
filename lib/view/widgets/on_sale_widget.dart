// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../consts/firebase_consts.dart';
import '../../model/product/product_model.dart';
import '../../services/global_method.dart';
import '../../services/utils.dart';
import '../../view_model/cart_provider.dart';
import '../../view_model/viewed_provider.dart';
import '../../view_model/wishlist_provider.dart';
import 'heart_btn.dart';
import 'price_widget.dart';
import 'text_widget.dart';

class OnSaleWidget extends HookConsumerWidget {
  const OnSaleWidget({
    super.key,
    required this.productModel,
  });

  final ProductModel productModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;
    final carts = ref.watch(cartProvider);
    final isInCart = carts.containsKey(productModel.id);
    final wishlist = ref.watch(wishlistProvider);
    final isInWishlist = wishlist.containsKey(productModel.id);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Theme.of(context).cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            ref
                .read(viewedProdProvider.notifier)
                .addProductToHistory(productId: productModel.id);
            context.go('/ProductDetails/${productModel.id}');
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FancyShimmerImage(
                      imageUrl: productModel.imageUrl,
                      height: size.width * 0.22,
                      width: size.width * 0.22,
                    ),
                    Column(
                      children: [
                        TextWidget(
                          text: productModel.isPiece ? '1Piece' : '1KG',
                          color: color,
                          textSize: 22,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: isInCart
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
                                        productId: productModel.id,
                                        quantity: 1,
                                        context: context,
                                      );
                                      ref
                                          .read(cartProvider.notifier)
                                          .fetchCart();
                                    },
                              child: Icon(
                                isInCart ? IconlyBold.bag2 : IconlyLight.bag2,
                                size: 22,
                                color: isInCart ? Colors.green : color,
                              ),
                            ),
                            HeartBTN(
                              productId: productModel.id,
                              isInWishlist: isInWishlist,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                PriceWidget(
                  salePrice: productModel.salePrice,
                  price: productModel.price,
                  textPrice: '1',
                  isOnSale: true,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextWidget(
                  text: productModel.title,
                  color: color,
                  textSize: 16,
                  isTitle: true,
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
