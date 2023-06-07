// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../model/cart/cart_model.dart';
import '../model/order/order_model.dart';
import '../services/global_method.dart';
import 'products_provider.dart';

class OrdersNotifier extends StateNotifier<List<OrderModel>> {
  OrdersNotifier() : super([]);

  void clearLocalOrders() {
    state = [];
  }

  Future<void> fetchOrders() async {
    final user = authInstance.currentUser;
    await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user!.uid)
        .get()
        .then((QuerySnapshot ordersSnapshot) {
      state = [];
      for (final element in ordersSnapshot.docs) {
        state.insert(
          0,
          OrderModel(
            orderId: element['orderId'] as String,
            userId: element['userId'] as String,
            productId: element['productId'] as String,
            userName: element['userName'] as String,
            price: element['price'] as double,
            imageUrl: element['imageUrl'] as String,
            quantity: element['quantity'] as int,
            orderDate: (element['orderDate'] as Timestamp).toDate(),
          ),
        );
      }
    });
  }

  Future<void> orderProducts(
    Map<String, CartModel> carts,
    WidgetRef ref,
    double total,
    BuildContext ctx,
  ) async {
    final user = authInstance.currentUser;
    final orderId = const Uuid().v4();

    carts.forEach((key, value) async {
      final getCurrProduct = ref.read(productsProvider.notifier).findProdById(
            value.productId,
          );
      try {
        // 注文登録
        await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
          'orderId': orderId,
          'userId': user!.uid,
          'productId': value.productId,
          'price': (getCurrProduct.isOnSale
                  ? getCurrProduct.salePrice
                  : getCurrProduct.price) *
              value.quantity,
          'totalPrice': total,
          'quantity': value.quantity,
          'imageUrl': getCurrProduct.imageUrlList[0],
          'userName': user.displayName,
          'orderDate': Timestamp.now(),
        });
        // 在庫を減らす
        final productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where('id', isEqualTo: getCurrProduct.id)
            .get();
        final stock = productSnapshot.docs[0]['stock'] as int;
        await FirebaseFirestore.instance
            .collection('products')
            .doc(getCurrProduct.id)
            .set(
          {
            'stock': stock - value.quantity,
          },
          SetOptions(merge: true),
        );
        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        await GlobalMethods.errorDialog(
          subtitle: error.toString(),
          context: ctx,
        );
      } finally {}
    });
  }
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<OrderModel>>(
  (ref) => OrdersNotifier(),
);
