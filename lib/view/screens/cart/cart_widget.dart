// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../model/cart/cart_model.dart';
import '../../../services/utils.dart';
import '../../../view_model/cart_provider.dart';
import '../../../view_model/products_provider.dart';
import '../../../view_model/wishlist_provider.dart';
import '../../widgets/heart_btn.dart';
import '../../widgets/text_widget.dart';

class CartWidget extends HookConsumerWidget {
  const CartWidget({
    super.key,
    required this.cartModel,
    required this.q,
  });

  final CartModel cartModel;
  final int q;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;
    final quantityTextController = useTextEditingController(text: q.toString());
    final currentProduct =
        ref.read(productsProvider.notifier).findProdById(cartModel.productId);
    final usedPrice = currentProduct.isOnSale
        ? currentProduct.salePrice
        : currentProduct.price;
    final wishlist = ref.watch(wishlistProvider);
    final isInWishlist = wishlist.containsKey(currentProduct.id);

    return GestureDetector(
      onTap: () {
        context.go('/ProductDetails/${cartModel.productId}');
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: size.width * 0.25,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FancyShimmerImage(
                        imageUrl: currentProduct.imageUrl,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: currentProduct.title,
                          color: color,
                          textSize: 20,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: size.width * 0.3,
                          child: Row(
                            children: [
                              _quantityController(
                                fct: () {
                                  if (quantityTextController.text == '1') {
                                    return;
                                  } else {
                                    ref
                                        .read(cartProvider.notifier)
                                        .reduceQuantityByOne(
                                          cartModel.productId,
                                        );
                                    quantityTextController.text = (int.parse(
                                              quantityTextController.text,
                                            ) -
                                            1)
                                        .toString();
                                  }
                                },
                                color: Colors.red,
                                icon: CupertinoIcons.minus,
                              ),
                              Flexible(
                                child: TextField(
                                  controller: quantityTextController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]'),
                                    ),
                                  ],
                                  onChanged: (v) {
                                    if (v.isEmpty) {
                                      quantityTextController.text = '1';
                                    } else {
                                      return;
                                    }
                                  },
                                ),
                              ),
                              _quantityController(
                                fct: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .increaseQuantityByOne(
                                        cartModel.productId,
                                      );
                                  quantityTextController.text =
                                      (int.parse(quantityTextController.text) +
                                              1)
                                          .toString();
                                },
                                color: Colors.green,
                                icon: CupertinoIcons.plus,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              await ref
                                  .read(cartProvider.notifier)
                                  .removeOneItem(
                                    cartId: cartModel.id,
                                    productId: cartModel.productId,
                                    quantity: cartModel.quantity,
                                  );
                            },
                            child: const Icon(
                              CupertinoIcons.cart_badge_minus,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          HeartBTN(
                            productId: currentProduct.id,
                            isInWishlist: isInWishlist,
                          ),
                          TextWidget(
                            text:
                                '\$${(usedPrice * int.parse(quantityTextController.text)).toStringAsFixed(2)}',
                            color: color,
                            textSize: 18,
                            maxLines: 1,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityController({
    required Function fct,
    required IconData icon,
    required Color color,
  }) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // ignore: avoid_dynamic_calls
              fct();
            },
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
