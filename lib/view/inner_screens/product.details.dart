// Flutter imports:
// ignore_for_file: unnecessary_statements

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../consts/firebase_consts.dart';
import '../../services/global_method.dart';
import '../../services/utils.dart';
import '../../view_model/cart_provider.dart';
import '../../view_model/products_provider.dart';
import '../../view_model/viewed_provider.dart';
import '../../view_model/wishlist_provider.dart';
import '../widgets/heart_btn.dart';
import '../widgets/text_widget.dart';

final quantityProvider = StateProvider((_) => 1);

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
    final quantity = ref.watch(quantityProvider);
    final quantityTextController =
        useTextEditingController(text: quantity.toString());
    final currentProduct =
        ref.read(productsProvider.notifier).findProdById(productId!);
    final usedPrice = currentProduct.isOnSale
        ? currentProduct.salePrice
        : currentProduct.price;
    final totalPrice = usedPrice * quantity;
    final carts = ref.watch(cartProvider);
    final isInCart = carts.containsKey(currentProduct.id);
    final wishlist = ref.watch(wishlistProvider);
    final isInWishlist = wishlist.containsKey(currentProduct.id);

    useEffect(
      () {
        ref
            .read(viewedProdProvider.notifier)
            .addProductToHistory(productId: currentProduct.id);
        return;
      },
      [],
    );

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                constraints: BoxConstraints.tightFor(height: size.height - 92),
                child: Scaffold(
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    centerTitle: true,
                    leading: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.canPop(context)
                            ? {
                                ref.read(quantityProvider.notifier).state = 1,
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
                    title: TextWidget(
                      text: 'Product details',
                      color: color,
                      textSize: 24,
                      isTitle: true,
                    ),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 48),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.4,
                            child: Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return Image.network(
                                  currentProduct.imageUrlList[index],
                                  fit: BoxFit.scaleDown,
                                  width: size.width,
                                );
                              },
                              autoplay: true,
                              itemCount: currentProduct.imageUrlList.length,
                              viewportFraction: 0.9,
                              scale: 0.8,
                              pagination: const SwiperPagination(
                                alignment: Alignment.bottomCenter,
                                builder: DotSwiperPaginationBuilder(
                                  color: Color.fromRGBO(150, 150, 150, 0.2),
                                  activeColor:
                                      Color.fromRGBO(150, 150, 150, 0.9),
                                  activeSize: 8,
                                  size: 7,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 22, right: 22),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextWidget(
                                      text: currentProduct.title,
                                      color: color,
                                      textSize: 25,
                                      isTitle: true,
                                    ),
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 0.2,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: HeartBTN(
                                          productId: currentProduct.id,
                                          isInWishlist: isInWishlist,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 30,
                                  right: 30,
                                ),
                                child: Row(
                                  children: [
                                    TextWidget(
                                      text: '${currentProduct.stock}',
                                      color: color,
                                      textSize: 16,
                                      isTitle: true,
                                    ),
                                    TextWidget(
                                      text: ' left in stock',
                                      color: color,
                                      textSize: 15,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 30,
                                  right: 30,
                                ),
                                child: Row(
                                  children: [
                                    TextWidget(
                                      text:
                                          '\$${usedPrice.toStringAsFixed(2)}/',
                                      color: Colors.red.shade300,
                                      textSize: 22,
                                      isTitle: true,
                                    ),
                                    TextWidget(
                                      text: currentProduct.isPiece
                                          ? 'Piece'
                                          : 'kg',
                                      color: color,
                                      textSize: 12,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Visibility(
                                      visible:
                                          // ignore: avoid_bool_literals_in_conditional_expressions
                                          currentProduct.isOnSale
                                              ? true
                                              : false,
                                      child: Text(
                                        '\$${currentProduct.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: color,
                                          decoration:
                                              TextDecoration.lineThrough,
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
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: Colors.black54,
                                          width: 0.2,
                                        ),
                                      ),
                                      child: TextWidget(
                                        text: 'Free delivery',
                                        color: Colors.black87,
                                        textSize: 18,
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
                                        text:
                                            'This product is already in your cart.',
                                        color: Colors.red.shade400,
                                        textSize: 18,
                                      ),
                                    )
                                  : Center(
                                      child: Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: color,
                                            width: 0.2,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            quantityController(
                                              fct: () {
                                                if (quantity == 1 ||
                                                    quantity == 0) {
                                                  return;
                                                } else {
                                                  final result = quantity - 1;
                                                  quantityTextController.text =
                                                      result.toString();
                                                  ref
                                                      .read(
                                                        quantityProvider
                                                            .notifier,
                                                      )
                                                      .state = result;
                                                }
                                              },
                                              icon: CupertinoIcons.minus,
                                              color: color,
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Flexible(
                                              child: TextField(
                                                controller:
                                                    quantityTextController,
                                                key: const ValueKey('quantity'),
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                ),
                                                textAlign: TextAlign.center,
                                                enabled: true,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(
                                                    RegExp('[0-9]'),
                                                  ),
                                                ],
                                                onChanged: (value) {
                                                  if (value.isEmpty) {
                                                    quantityTextController
                                                        .text = '1';
                                                  } else {
                                                    return;
                                                  }
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            quantityController(
                                              fct: () async {
                                                final result = quantity + 1;
                                                if (quantity >
                                                    currentProduct.stock - 1) {
                                                  final fToast = FToast();
                                                  await GlobalMethods.showToast(
                                                    fToast,
                                                    context,
                                                    'Due to limited stock, you cannot select more',
                                                  );
                                                  return;
                                                }
                                                quantityTextController.text =
                                                    result.toString();
                                                ref
                                                    .read(
                                                      quantityProvider.notifier,
                                                    )
                                                    .state = result;
                                              },
                                              icon: CupertinoIcons.plus,
                                              color: color,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 22,
                                  right: 22,
                                ),
                                child: Divider(
                                  thickness: 0.1,
                                  color: color,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  left: 22,
                                  right: 22,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: 'Product details',
                                      color: color,
                                      textSize: 18,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                      ),
                                      child: Text(
                                        currentProduct.description,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: color,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            height: 92,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: color,
                  width: 0.2,
                ),
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
                        color: color,
                        textSize: 20,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            TextWidget(
                              text: '\$${totalPrice.toStringAsFixed(2)}/',
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
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: isInCart
                          ? null
                          : () {
                              final user = authInstance.currentUser;
                              if (user == null) {
                                GlobalMethods.errorDialog(
                                  subtitle: 'No user found, Please login first',
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
                              ref.read(cartProvider.notifier).fetchCart();
                            },
                      borderRadius: BorderRadius.circular(30),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                          left: 20,
                          bottom: 12,
                          right: 20,
                        ),
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
        ),
      ],
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
