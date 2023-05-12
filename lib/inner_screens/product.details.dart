// Flutter imports:
// ignore_for_file: unnecessary_statements

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import '../widgets/heart_btn.dart';
import '../widgets/text_widget.dart';

class QuantityProvider extends StateNotifier<String> {
  QuantityProvider() : super('1');

  // ignore: use_setters_to_change_properties
  void setText(String text) {
    state = text;
  }
}

final quantityProvider = StateNotifierProvider<QuantityProvider, String>(
  (ref) => QuantityProvider(),
);

class ProductDetails extends HookConsumerWidget {
  const ProductDetails({
    super.key,
    required this.productId,
  });

  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;
    final quantityTextController = useTextEditingController(text: '1');
    final quantity = ref.watch(quantityProvider);
    final currentProduct =
        ref.read(productsProvider.notifier).findProdById(productId!);
    final usedPrice = currentProduct.isOnSale
        ? currentProduct.salePrice
        : currentProduct.price;
    final totalPrice = usedPrice * int.parse(quantity);
    final carts = ref.watch(cartProvider);
    final isInCart = carts.containsKey(currentProduct.id);
    final wishlist = ref.watch(wishlistProvider);
    final isInWishlist = wishlist.containsKey(currentProduct.id);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.canPop(context)
                ? {
                    ref.read(quantityProvider.notifier).setText('1'),
                    // ref
                    //     .read(viewedProdProvider.notifier)
                    //     .addProductToHistory(productId: currentProduct.id),
                  }
                : null;
            context.go('/BottomBarScreen');
          },
          child: Icon(
            IconlyLight.arrowLeft2,
            color: color,
            size: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: FancyShimmerImage(
              imageUrl: currentProduct.imageUrl,
              boxFit: BoxFit.scaleDown,
              width: size.width,
            ),
          ),
          Flexible(
            flex: 3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: currentProduct.title,
                            color: color,
                            textSize: 25,
                            isTitle: true,
                          ),
                        ),
                        HeartBTN(
                          productId: currentProduct.id,
                          isInWishlist: isInWishlist,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      children: [
                        TextWidget(
                          text: '\$${usedPrice.toStringAsFixed(2)}/',
                          color: Colors.green,
                          textSize: 22,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: currentProduct.isPiece ? 'Piece' : 'kg',
                          color: color,
                          textSize: 12,
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
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(63, 200, 101, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextWidget(
                            text: 'Free delivery',
                            color: Colors.white,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isInCart
                      ? Container(
                          alignment: Alignment.center,
                          child: TextWidget(
                            text: 'This product is already in your cart!',
                            color: color,
                            textSize: 20,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            quantityController(
                              fct: () {
                                if (quantity == '1') {
                                  return;
                                } else {
                                  final result =
                                      (int.parse(quantity) - 1).toString();
                                  quantityTextController.text = result;
                                  ref
                                      .read(quantityProvider.notifier)
                                      .setText(result);
                                }
                              },
                              icon: CupertinoIcons.minus,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: TextField(
                                controller: quantityTextController,
                                key: const ValueKey('quantity'),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                ),
                                textAlign: TextAlign.center,
                                cursorColor: Colors.green,
                                enabled: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    quantityTextController.text = '1';
                                  } else {
                                    return;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            quantityController(
                              fct: () {
                                final result =
                                    (int.parse(quantity) + 1).toString();
                                quantityTextController.text = result;
                                ref
                                    .read(quantityProvider.notifier)
                                    .setText(result);
                              },
                              icon: CupertinoIcons.plus,
                              color: Colors.green,
                            ),
                          ],
                        ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: 'Total',
                                color: Colors.red.shade300,
                                textSize: 20,
                                isTitle: true,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              FittedBox(
                                child: Row(
                                  children: [
                                    TextWidget(
                                      text:
                                          '\$${totalPrice.toStringAsFixed(2)}/',
                                      color: color,
                                      textSize: 20,
                                      isTitle: true,
                                    ),
                                    TextWidget(
                                      text: currentProduct.isPiece
                                          ? '${quantity}piece'
                                          : '${quantity}kg',
                                      color: color,
                                      textSize: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Material(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
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
                                        productId: currentProduct.id,
                                        quantity: int.parse(
                                          quantityTextController.text,
                                        ),
                                        context: context,
                                      );
                                      ref
                                          .read(cartProvider.notifier)
                                          .fetchCart();
                                    },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: TextWidget(
                                  text: isInCart ? 'In cart' : 'Add to cart',
                                  color: Colors.white,
                                  textSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget quantityController({
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
