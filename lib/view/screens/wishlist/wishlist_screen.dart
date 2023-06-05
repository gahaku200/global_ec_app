// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../../services/global_method.dart';
import '../../../services/utils.dart';
import '../../../view_model/wishlist_provider.dart';
import '../../widgets/back_widget.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'wishlist_widget.dart';

class WishlistScreen extends HookConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final wishlist = ref.watch(wishlistProvider);
    final wishlistItemsList = wishlist.values.toList().reversed.toList();
    final wishlistNotifier = ref.read(wishlistProvider.notifier);

    return wishlistItemsList.isEmpty
        ? const EmptyScreen(
            imagePath: 'assets/images/offers/shopping-cart.jpeg',
            title: 'Your Wishlist is Empty',
            subtitle: 'Explore more and shortlist some items',
            buttonText: 'Add a wish',
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: const BackWidget(),
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: TextWidget(
                text: 'Wishlist (${wishlistItemsList.length})',
                color: color,
                textSize: 22,
                isTitle: true,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    GlobalMethods.warningDialog(
                      title: 'Empty your wishlist?',
                      subtitle: 'Are you sure?',
                      fct: () async {
                        await wishlistNotifier.clearOnlineWishlist();
                        wishlistNotifier.clearLocalWishlist();
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
            body: ListView.builder(
              itemCount: wishlistItemsList.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                  child: WishlistWidget(
                    wishlistModel: wishlistItemsList[index],
                  ),
                );
              },
            ),
          );
  }
}
