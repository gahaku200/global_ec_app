// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../model/order/order_model.dart';

class OrdersNotifier extends StateNotifier<List<OrderModel>> {
  OrdersNotifier() : super([]);
  List<OrderModel> get getOrders {
    return state;
  }

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
            orderId: element.get('orderId').toString(),
            userId: element.get('userId').toString(),
            productId: element.get('productId').toString(),
            userName: element.get('userName').toString(),
            price: element.get('price').toString(),
            imageUrl: element.get('imageUrl').toString(),
            quantity: element.get('quantity').toString(),
            orderDate: element.get('orderDate').toString(),
          ),
        );
      }
    });
  }
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<OrderModel>>(
  (ref) => OrdersNotifier(),
);
