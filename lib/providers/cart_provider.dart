// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../models/cart_model.dart';

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

  Map<String, CartModel> get getCartItems {
    return state;
  }

  void addProductsToCart({
    required String productId,
    required int quantity,
  }) {
    state.putIfAbsent(
      productId,
      () => CartModel(
        id: DateTime.now().toString(),
        productId: productId,
        quantity: quantity,
      ),
    );
    changeState();
  }

  void reduceQuantityByOne(String productId) {
    state.update(
      productId,
      (value) => CartModel(
        id: value.id,
        productId: productId,
        quantity: value.quantity - 1,
      ),
    );
    changeState();
  }

  void increaseQuantityByOne(String productId) {
    state.update(
      productId,
      (value) => CartModel(
        id: value.id,
        productId: productId,
        quantity: value.quantity + 1,
      ),
    );
    changeState();
  }

  void removeOneItem(String productId) {
    state.remove(productId);
    changeState();
  }

  void clearCart() {
    state = {};
  }

  void changeState() {
    final newState = state;
    state = {};
    state = newState;
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>(
  (ref) => CartNotifier(),
);
