// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/consts.dart';
import '../consts/firebase_consts.dart';
import '../view_model/cart_provider.dart';
import '../view_model/orders_provider.dart';
import '../view_model/products_provider.dart';
import '../view_model/wishlist_provider.dart';

final isFirstProvider = StateProvider((_) => true);

// ignore: must_be_immutable
class FetchScreen extends HookConsumerWidget {
  FetchScreen({super.key});

  List<String> images = Consts.authImagesPaths;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFirst = ref.watch(isFirstProvider);
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          images.shuffle();
          Future.delayed(const Duration(microseconds: 5), () async {
            final user = authInstance.currentUser;
            if (user == null) {
              await ref.read(productsProvider.notifier).fetchProducts();
              ref.read(cartProvider.notifier).clearLocalCart();
              ref.read(wishlistProvider.notifier).clearLocalWishlist();
              ref.read(ordersProvider.notifier).clearLocalOrders();
            } else {
              await ref.read(productsProvider.notifier).fetchProducts();
              await ref.read(cartProvider.notifier).fetchCart();
              await ref.read(wishlistProvider.notifier).fetchWishlist();
              await ref.read(ordersProvider.notifier).fetchOrders();
            }
            if (isFirst) {
              ref.read(isFirstProvider.notifier).state = false;
              context.go('/BottomBarScreen');
            }
          });
        });
        return;
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            images[0],
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
  }
}
