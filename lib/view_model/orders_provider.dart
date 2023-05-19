// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../model/order/order_model.dart';

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
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<OrderModel>>(
  (ref) => OrdersNotifier(),
);
