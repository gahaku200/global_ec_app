// ignore_for_file: avoid_dynamic_calls

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../model/cart/cart_model.dart';
import '../services/global_method.dart';

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<void> fetchCart() async {
    final user = authInstance.currentUser;
    final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();
    final userCart = userDoc.get('userCart') as List<dynamic>;

    state = Map<String, CartModel>.fromEntries(
      userCart.map((cartItem) {
        final cartModel = CartModel(
          id: cartItem['cartId'] as String,
          productId: cartItem['productId'] as String,
          quantity: cartItem['quantity'] as int,
        );
        return MapEntry(cartItem['productId'] as String, cartModel);
      }),
    );
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

  Future<String> confirmStock(WidgetRef ref, BuildContext ctx) async {
    try {
      var overStock = 0;
      final firebaseInstance = FirebaseFirestore.instance;

      for (final value in state.values) {
        final productSnapshot = await firebaseInstance
            .collection('products')
            .where('id', isEqualTo: value.productId)
            .get();

        final stock = productSnapshot.docs[0]['stock'] as int;

        if (value.quantity > stock) {
          overStock++;
          final userDoc = firebaseInstance.collection('users').doc(uid);
          final userSnapshot = await userDoc.get();
          final userCart = userSnapshot.data()!['userCart'] as List<dynamic>;

          // ユーザーカート内の特定の要素を更新
          final updatedUserCart = userCart.map((cartItem) {
            if (cartItem['cartId'] == value.id &&
                cartItem['productId'] == value.productId) {
              return {
                'cartId': cartItem['cartId'],
                'productId': cartItem['productId'],
                'quantity': stock,
              };
            } else {
              return cartItem;
            }
          }).toList();

          // ユーザードキュメントを削除してから更新後のデータを保存
          await userDoc.update({
            'userCart': FieldValue.arrayRemove(userCart),
          });
          await userDoc.update({
            'userCart': FieldValue.arrayUnion(updatedUserCart),
          });

          await GlobalMethods.errorDialog(
            subtitle:
                'You cannot order ${productSnapshot.docs[0]['title']} because there are $stock left in stock.',
            context: ctx,
          );
        }
      }
      return overStock == 0 ? 'success' : 'failed';
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      await GlobalMethods.errorDialog(
        subtitle: error.toString(),
        context: ctx,
      );
      return 'failed';
    }
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>(
  (ref) => CartNotifier(),
);
