// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../services/global_method.dart';
import '../../../services/utils.dart';
import '../../../view_model/cart_provider.dart';
import '../../../view_model/orders_provider.dart';
import '../../../view_model/products_provider.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'cart_widget.dart';

class CartScreen extends HookConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final carts = ref.watch(cartProvider);
    final cartItemsList = carts.values.toList().reversed.toList();
    final cartNotifier = ref.read(cartProvider.notifier);

    return carts.isEmpty
        ? const EmptyScreen(
            title: 'Your cart is empty',
            subtitle: 'Add something and make me happy :)',
            buttonText: 'Shop now',
            imagePath: 'assets/images/offers/shopping-cart.jpeg',
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(
                text: 'Cart (${carts.length})',
                color: color,
                textSize: 22,
                isTitle: true,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    GlobalMethods.warningDialog(
                      title: 'Empty your cart?',
                      subtitle: 'Are you sure?',
                      fct: () async {
                        await cartNotifier.clearOnlineCart();
                        cartNotifier.clearLocalCart();
                      },
                      context: context,
                    );
                  },
                  icon: Icon(
                    IconlyBroken.delete,
                    color: color,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItemsList.length,
                    itemBuilder: (ctx, index) {
                      return CartWidget(
                        cartModel: cartItemsList[index],
                        q: cartItemsList[index].quantity,
                      );
                    },
                  ),
                ),
                _checkout(
                  utils: utils,
                  color: color,
                  ref: ref,
                  ctx: context,
                ),
              ],
            ),
          );
  }

  Widget _checkout({
    required Utils utils,
    required Color color,
    required WidgetRef ref,
    required BuildContext ctx,
  }) {
    final size = utils.getScreenSize;
    final carts = ref.watch(cartProvider);
    final productsNotifier = ref.read(productsProvider.notifier);
    final cartNotifier = ref.read(cartProvider.notifier);
    final ordersNotifier = ref.read(ordersProvider.notifier);

    var total = 0.0;
    carts.forEach((key, value) {
      final getCurrProduct = productsNotifier.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: color,
            width: 0.1,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: size.height * 0.1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Row(
                children: [
                  TextWidget(
                    text: 'Total  ',
                    color: color,
                    textSize: 18,
                  ),
                  TextWidget(
                    text: '\$ ${total.toStringAsFixed(2)}',
                    color: color,
                    textSize: 20,
                    isTitle: true,
                  ),
                ],
              ),
              const Spacer(),
              Material(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () async {
                    final result = await cartNotifier.confirmStock(ref, ctx);
                    if (result == 'success') {
                      await ordersNotifier.orderProducts(
                        carts,
                        ref,
                        total,
                        ctx,
                      );
                      await cartNotifier.clearOnlineCart();
                      cartNotifier.clearLocalCart();
                      await ref.read(ordersProvider.notifier).fetchOrders();
                      final fToast = FToast();
                      await GlobalMethods.showToast(
                        fToast,
                        ctx,
                        'Your order has been placed',
                      );
                    } else if (result == 'failed') {
                      await cartNotifier.fetchCart();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 18,
                      bottom: 10,
                      right: 18,
                    ),
                    child: TextWidget(
                      text: 'Order Now',
                      color: Colors.white,
                      textSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
