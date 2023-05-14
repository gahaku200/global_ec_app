// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../consts/firebase_consts.dart';
import '../../../model/viewed/viewed_model.dart';
import '../../../services/global_method.dart';
import '../../../services/utils.dart';
import '../../../view_model/cart_provider.dart';
import '../../../view_model/products_provider.dart';
import '../../widgets/text_widget.dart';

class ViewedRecentlyWidget extends HookConsumerWidget {
  const ViewedRecentlyWidget({
    super.key,
    required this.viewedProdModel,
  });

  final ViewedProdModel viewedProdModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;
    final currentProduct = ref
        .read(productsProvider.notifier)
        .findProdById(viewedProdModel.productId);
    final usedPrice = currentProduct.isOnSale
        ? currentProduct.salePrice
        : currentProduct.price;
    final carts = ref.watch(cartProvider);
    final isInCart = carts.containsKey(currentProduct.id);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () {
          context.go('/ProductDetails/${currentProduct.id}');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FancyShimmerImage(
              imageUrl: currentProduct.imageUrl,
              height: size.width * 0.27,
              width: size.width * 0.25,
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              children: [
                TextWidget(
                  text: currentProduct.title,
                  color: color,
                  textSize: 24,
                  maxLines: 2,
                  isTitle: true,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextWidget(
                  text: '\$${usedPrice.toStringAsFixed(2)}',
                  color: color,
                  textSize: 20,
                  maxLines: 1,
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
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
                            quantity: 1,
                            context: context,
                          );
                          ref.read(cartProvider.notifier).fetchCart();
                        },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      isInCart ? Icons.check : IconlyBold.plus,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
