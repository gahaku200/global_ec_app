// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../services/utils.dart';
import '../../view_model/products_provider.dart';
import '../widgets/back_widget.dart';
import '../widgets/empty_products_widget.dart';
import '../widgets/on_sale_widget.dart';
import '../widgets/text_widget.dart';

class OnSaleScreen extends HookConsumerWidget {
  const OnSaleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsOnSale =
        ref.read(productsProvider.notifier).getOnSaleProducts;
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'Product on sale',
          color: color,
          textSize: 24,
          isTitle: true,
        ),
      ),
      body: productsOnSale.isEmpty
          ? const EmptyProdWidget(
              text: 'No products on sale yet!,\nStay tuned',
            )
          : GridView.count(
              // shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.45),
              children: List.generate(
                productsOnSale.length,
                (index) {
                  return OnSaleWidget(productModel: productsOnSale[index]);
                },
              ),
            ),
    );
  }
}
