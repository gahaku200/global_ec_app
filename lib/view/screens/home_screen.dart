// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../consts/consts.dart';
import '../../services/utils.dart';
import '../../view_model/products_provider.dart';
import '../widgets/on_sale_widget.dart';
import '../widgets/product_widget.dart';
import '../widgets/text_widget.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;
    final allProducts = ref.watch(productsProvider);
    final productsOnSale =
        ref.read(productsProvider.notifier).getOnSaleProducts;
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    );
    final currentIndex = useState(0);

    useEffect(
      () {
        final timer = Timer.periodic(const Duration(seconds: 5), (timer) {
          controller.forward().then((value) {
            currentIndex.value =
                (currentIndex.value + 1) % Consts.offerImages.length;
            controller.reset();
          });
        });
        return timer.cancel;
      },
      [],
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 8),
              child: Text(
                'Sugoi！Collection',
                maxLines: 10,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.30,
              child: Stack(
                children: [
                  Image.asset(
                    Consts.offerImages[currentIndex.value],
                    fit: BoxFit.fill,
                  ),
                  FadeTransition(
                    opacity: controller,
                    child: Image.asset(
                      Consts.offerImages[
                          (currentIndex.value + 1) % Consts.offerImages.length],
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'ON SALE',
                    color: Colors.red,
                    textSize: 22,
                    isTitle: true,
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/OnSaleScreen');
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.25,
              child: ListView.builder(
                itemCount:
                    productsOnSale.length < 10 ? productsOnSale.length : 10,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return OnSaleWidget(
                    productModel: productsOnSale[index],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'All products',
                    color: color,
                    textSize: 22,
                    isTitle: true,
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/AllProductsScreen');
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              // crossAxisSpacing: 10,
              childAspectRatio: size.width / (size.height * 0.61),
              children: List.generate(
                allProducts.length < 4 ? allProducts.length : 4,
                (index) {
                  return ProductWidget(productModel: allProducts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
