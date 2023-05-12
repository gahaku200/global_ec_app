// Package imports:
// ignore_for_file: avoid_dynamic_calls

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../models/cart_model.dart';

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

  Map<String, CartModel> get getCartItems {
    return state;
  }

  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchCart() async {
    final user = authInstance.currentUser;
    final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();
    final leng = int.parse(userDoc.get('userCart').length.toString());
    for (var i = 0; i < leng; i++) {
      state.putIfAbsent(
        userDoc.get('userCart')[i]['productId'].toString(),
        () => CartModel(
          id: userDoc.get('userCart')[i]['cartId'].toString(),
          productId: userDoc.get('userCart')[i]['productId'].toString(),
          quantity:
              int.parse(userDoc.get('userCart')[i]['quantity'].toString()),
        ),
      );
    }
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

  Future<void> removeOneItem({
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    final user = authInstance.currentUser;
    final userDoc = await userCollection.doc(user!.uid).get();
    final userCart = userDoc.data()!['userCart'];

    // 削除対象のオブジェクトをフィルタリングする
    userCart.removeWhere(
      (dynamic cartItem) =>
          cartItem['productId'] == productId && cartItem['cartId'] == cartId,
    );

    // 更新された配列をFirestoreに保存する
    await userCollection.doc(user.uid).update({
      'userCart': userCart,
    });

    state.remove(productId);
    await fetchCart();
    changeState();
  }

  Future<void> clearOnlineCart() async {
    final user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userCart': [],
    });
    state = {};
  }

  void clearLocalCart() {
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
