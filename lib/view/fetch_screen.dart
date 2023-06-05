// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/consts.dart';
import '../consts/firebase_consts.dart';
import '../view_model/cart_provider.dart';
import '../view_model/category_provider.dart';
import '../view_model/orders_provider.dart';
import '../view_model/products_provider.dart';
import '../view_model/wishlist_provider.dart';
import 'screens/btm_bar.dart';

final isFirstProvider = StateProvider((_) => true);

// ignore: must_be_immutable
class FetchScreen extends HookConsumerWidget {
  FetchScreen({super.key});

  List<String> images = Consts.authImagesPaths;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFirst = ref.watch(isFirstProvider);
    final isFirstNotifier = ref.read(isFirstProvider.notifier);
    final productsNotifier = ref.read(productsProvider.notifier);
    final cartNotifier = ref.read(cartProvider.notifier);
    final wishlistNotifier = ref.read(wishlistProvider.notifier);
    final ordersNotifier = ref.read(ordersProvider.notifier);
    final categoryNotifier = ref.read(categoryProvider.notifier);
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          images.shuffle();
          Future.delayed(const Duration(microseconds: 5), () async {
            final user = authInstance.currentUser;
            if (user == null) {
              await productsNotifier.fetchProducts();
              cartNotifier.clearLocalCart();
              wishlistNotifier.clearLocalWishlist();
              ordersNotifier.clearLocalOrders();
            } else {
              await productsNotifier.fetchProducts();
              await cartNotifier.fetchCart();
              await wishlistNotifier.fetchWishlist();
              await ordersNotifier.fetchOrders();
            }
            await categoryNotifier.fetchCategory();
            if (isFirst) {
              isFirstNotifier.state = false;
            }
          });
        });
        return;
      },
    );

    if (isFirst) {
      return Scaffold(
        body: Stack(
          children: [
            Image.asset(
              images[Random().nextInt(9)],
              fit: BoxFit.cover,
              height: double.infinity,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            const Center(
              child: SpinKitFadingFour(
                color: Colors.white,
              ),
            )
          ],
        ),
      );
    } else {
      return BottomBarScreen();
    }
  }
}
