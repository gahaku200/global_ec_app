// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../models/wishlist_model.dart';

class WishlistNotifier extends StateNotifier<Map<String, WishlistModel>> {
  WishlistNotifier() : super({});

  Map<String, WishlistModel> get getWishlistItems {
    return state;
  }

  void addRemoveProductToWishlist({required String productId}) {
    if (state.containsKey(productId)) {
      removeOneItem(productId);
    } else {
      state.putIfAbsent(
        productId,
        () => WishlistModel(
          id: DateTime.now().toString(),
          productId: productId,
        ),
      );
    }
    changeState();
  }

  void removeOneItem(String productId) {
    state.remove(productId);
    changeState();
  }

  void clearWishlist() {
    state = {};
  }

  void changeState() {
    final newState = state;
    state = {};
    state = newState;
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, Map<String, WishlistModel>>(
  (ref) => WishlistNotifier(),
);
