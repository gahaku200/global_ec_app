// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../model/product/product_model.dart';
import '../../services/utils.dart';
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

    return productModel.stock < 1
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.go('/ProductDetails/${productModel.id}');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FancyShimmerImage(
                        imageUrl: productModel.imageUrlList[0],
                        height: size.width * 0.32,
                        width: size.width * 0.4,
                      ),
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
                  ],
                ),
              ),
            ),
          );
  }
}
