// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import '../../../consts/firebase_consts.dart';
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
            imagePath: 'assets/images/offers/Offer1.jpg',
          )
        : Scaffold(
            appBar: AppBar(
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
                _checkout(
                  utils: utils,
                  color: color,
                  ref: ref,
                  ctx: context,
                ),
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

    var total = 0.0;
    carts.forEach((key, value) {
      final getCurrProduct = productsNotifier.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  final user = authInstance.currentUser;
                  final orderId = const Uuid().v4();

                  carts.forEach((key, value) async {
                    final getCurrProduct = productsNotifier.findProdById(
                      value.productId,
                    );
                    try {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .set({
                        'orderId': orderId,
                        'userId': user!.uid,
                        'productId': value.productId,
                        'price': (getCurrProduct.isOnSale
                                ? getCurrProduct.salePrice
                                : getCurrProduct.price) *
                            value.quantity,
                        'totalPrice': total,
                        'quantity': value.quantity,
                        'imageUrl': getCurrProduct.imageUrl,
                        'userName': user.displayName,
                        'orderDate': Timestamp.now(),
                      });
                      // ignore: avoid_catches_without_on_clauses
                    } catch (error) {
                      await GlobalMethods.errorDialog(
                        subtitle: error.toString(),
                        context: ctx,
                      );
                    } finally {}
                  });
                  await cartNotifier.clearOnlineCart();
                  cartNotifier.clearLocalCart();
                  await ref.read(ordersProvider.notifier).fetchOrders();
                  await Fluttertoast.showToast(
                    msg: 'Your order has been placed',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextWidget(
                    text: 'Order Now',
                    color: Colors.white,
                    textSize: 20,
                  ),
                ),
              ),
            ),
            const Spacer(),
            FittedBox(
              child: TextWidget(
                text: 'Total: \$${total.toStringAsFixed(2)}',
                color: color,
                textSize: 18,
                isTitle: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
