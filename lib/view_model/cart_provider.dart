// ignore_for_file: avoid_dynamic_calls

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../model/cart/cart_model.dart';

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchCart() async {
    final user = authInstance.currentUser;
    final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();
    final leng = int.parse(userDoc.get('userCart').length.toString());
    for (var i = 0; i < leng; i++) {
      state.putIfAbsent(
        userDoc['userCart'][i]['productId'] as String,
        () => CartModel(
          id: userDoc['userCart'][i]['cartId'] as String,
          productId: userDoc['userCart'][i]['productId'] as String,
          quantity: userDoc['userCart'][i]['quantity'] as int,
        ),
      );
    }
    state = {...state};
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
    state = {...state};
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
    state = {...state};
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
    state = {...state};
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
}

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>(
  (ref) => CartNotifier(),
);
