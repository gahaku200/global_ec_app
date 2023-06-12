// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../model/product/product_model.dart';
import '../../services/utils.dart';
import '../../view_model/wishlist_provider.dart';
import 'heart_btn.dart';
import 'price_widget.dart';
import 'text_widget.dart';

class ProductWidget extends HookConsumerWidget {
  const ProductWidget({
    super.key,
    required this.productModel,
  });

  final ProductModel productModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;
    final quantityTextController = useTextEditingController(text: '1');
    final wishlist = ref.watch(wishlistProvider);
    final isInWishlist = wishlist.containsKey(productModel.id);

    return productModel.stock < 1
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(8),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).cardColor,
              child: InkWell(
                onTap: () {
                  context.go('/ProductDetails/${productModel.id}');
                },
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FancyShimmerImage(
                            imageUrl: productModel.imageUrlList[0],
                            height: size.width * 0.32,
                            width: size.width * 0.45,
                          ),
                        ),
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: HeartBTN(
                              productId: productModel.id,
                              isInWishlist: isInWishlist,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: TextWidget(
                        text: productModel.title,
                        color: color,
                        maxLines: 1,
                        textSize: 18,
                        isTitle: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: PriceWidget(
                        salePrice: productModel.salePrice,
                        price: productModel.price,
                        textPrice: quantityTextController.text,
                        isOnSale: productModel.isOnSale,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
