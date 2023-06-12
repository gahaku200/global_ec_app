// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../model/cart/cart_model.dart';
import '../../../services/global_method.dart';
import '../../../services/utils.dart';
import '../../../view_model/cart_provider.dart';
import '../../../view_model/products_provider.dart';
import '../../widgets/text_widget.dart';

class CartWidget extends HookConsumerWidget {
  const CartWidget({
    super.key,
    required this.cartModel,
  });

  final CartModel cartModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;
    final carts = ref.watch(cartProvider);
    final quantityTextController = TextEditingController(
      text: carts.values
          .firstWhere(
            (element) => element.productId == cartModel.productId,
          )
          .quantity
          .toString(),
    );
    final currentProduct =
        ref.read(productsProvider.notifier).findProdById(cartModel.productId);
    final usedPrice = currentProduct.isOnSale
        ? currentProduct.salePrice
        : currentProduct.price;
    final cartNotifier = ref.read(cartProvider.notifier);

    return GestureDetector(
      onTap: () {
        context.go('/ProductDetails/${cartModel.productId}');
      },
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
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
              Expanded(
                child: SizedBox(
                  height: size.width * 0.25,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: currentProduct.title,
                              color: color,
                              textSize: 20,
                              isTitle: true,
                            ),
                            InkWell(
                              onTap: () async {
                                await cartNotifier.removeOneItem(
                                  cartId: cartModel.id,
                                  productId: cartModel.productId,
                                );
                              },
                              child: const Icon(
                                CupertinoIcons.cart_badge_minus,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width * 0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: color,
                                  width: 0.2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _quantityController(
                                    fct: () {
                                      if (quantityTextController.text == '1' ||
                                          quantityTextController.text == '0') {
                                        return;
                                      } else {
                                        cartNotifier.reduceQuantityByOne(
                                          cartModel.productId,
                                        );
                                        quantityTextController
                                            .text = (int.parse(
                                                  quantityTextController.text,
                                                ) -
                                                1)
                                            .toString();
                                      }
                                    },
                                    color: color,
                                    icon: CupertinoIcons.minus,
                                  ),
                                  Flexible(
                                    child: TextField(
                                      controller: quantityTextController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      textAlign: TextAlign.center,
                                      enabled: true,
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
                                    fct: () async {
                                      if (int.parse(
                                            quantityTextController.text,
                                          ) >
                                          currentProduct.stock - 1) {
                                        final fToast = FToast();
                                        await GlobalMethods.showToast(
                                          fToast,
                                          context,
                                          'Due to limited stock, you cannot select more',
                                        );
                                        return;
                                      }
                                      cartNotifier.increaseQuantityByOne(
                                        cartModel.productId,
                                      );
                                      quantityTextController.text = (int.parse(
                                                quantityTextController.text,
                                              ) +
                                              1)
                                          .toString();
                                    },
                                    color: color,
                                    icon: CupertinoIcons.plus,
                                  ),
                                ],
                              ),
                            ),
                            TextWidget(
                              text:
                                  '\$ ${(usedPrice * int.parse(quantityTextController.text)).toStringAsFixed(2)}',
                              color: color,
                              textSize: 18,
                              maxLines: 1,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
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
        child: InkWell(
          onTap: () {
            // ignore: avoid_dynamic_calls
            fct();
          },
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
