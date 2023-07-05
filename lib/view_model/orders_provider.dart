// ignore_for_file: avoid_dynamic_calls, avoid_catches_without_on_clauses

// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../model/cart/cart_model.dart';
import '../model/order/order_model.dart';
import '../services/global_method.dart';
import 'products_provider.dart';
import 'user_provider.dart';

class OrdersNotifier extends StateNotifier<List<OrderModel>> {
  OrdersNotifier() : super([]);

  void clearLocalOrders() {
    state = [];
  }

  Future<void> fetchOrders() async {
    final user = authInstance.currentUser;
    final orderArray = <OrderModel>[];
    await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user!.uid)
        .get()
        .then((QuerySnapshot ordersSnapshot) {
      for (final element in ordersSnapshot.docs) {
        orderArray.insert(
          0,
          OrderModel(
            orderId: element['orderId'] as String,
            userId: element['userId'] as String,
            productId: element['productId'] as String,
            userName: element['userName'] as String,
            price: element['price'] as double,
            imageUrl: element['imageUrl'] as String,
            quantity: element['quantity'] as int,
            orderStatus: element['orderStatus'] as int,
            orderDate: (element['orderDate'] as Timestamp).toDate(),
          ),
        );
      }
      orderArray.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    });
    state = [];
    state = orderArray;
  }

  Future<String> orderProducts(
    WidgetRef ref,
    double total,
    BuildContext ctx,
  ) async {
    final user = ref.watch(userProvider);
    final fToast = FToast();
    final amount = (total * 100).toInt().toString();
    try {
      // 1. Cloud Functions 上で PaymentIntent を作成
      final callable =
          FirebaseFunctions.instance.httpsCallable('createPaymentIntent');
      // ignore: inference_failure_on_function_invocation
      final result = await callable.call(
        {
          'amount': amount,
          'customerId': user.stripeCustomerId,
        },
      );
      final data = result.data;

      // 2. PaymentSheet を初期化
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Sugoi！Collection',
          paymentIntentClientSecret: data['paymentIntent'] as String,
          customerEphemeralKeySecret: data['ephemeralKey'] as String,
          customerId: data['customer'] as String,
        ),
      );

      // 3. PaymentSheet を表示
      await Stripe.instance.presentPaymentSheet();

      // 4. 決済内容を取得
      // final paymentIntent = await Stripe.instance.retrievePaymentIntent(
      //   data['paymentIntent'] as String,
      // );
      if (user.stripeCustomerId == '') {
        await ref
            .read(userProvider.notifier)
            .registerUserStripeCustomerId(data['customer'] as String);
      }
      return 'success';
    } on StripeException catch (e) {
      final error = e.error;
      switch (error.code) {
        case FailureCode.Canceled:
          log('The order was canceled', error: e);
          await GlobalMethods.showToast(
            fToast,
            ctx,
            'The order was canceled',
          );
          break;
        case FailureCode.Failed:
          log('A Stripe Error occured', error: e);
          await GlobalMethods.showToast(
            fToast,
            ctx,
            'A Stripe Error occured',
          );
          break;
        case FailureCode.Timeout:
          log('Request timed out', error: e);
          await GlobalMethods.showToast(
            fToast,
            ctx,
            'Request timed out',
          );
          break;
      }
      return 'failed';
    } on FirebaseFunctionsException catch (e) {
      log('A FirebaseFunctions Error occured', error: e);
      await GlobalMethods.showToast(
        fToast,
        ctx,
        'A FirebaseFunctions Error occured',
      );
      return 'failed';
    } catch (e) {
      log('An unknown error has occurred', error: e);
      await GlobalMethods.showToast(
        fToast,
        ctx,
        'An unknown error has occurred',
      );
      return 'failed';
    }
  }

  Future<void> saveOrderedProducts(
    Map<String, CartModel> carts,
    WidgetRef ref,
    double total,
    BuildContext ctx,
  ) async {
    final user = authInstance.currentUser;

    carts.forEach((key, value) async {
      final orderId = const Uuid().v4();
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
          'orderStatus': 0,
          'orderDate': Timestamp.now(),
        });
        // 在庫を減らす
        final productRef = FirebaseFirestore.instance
            .collection('products')
            .doc(getCurrProduct.id);

        await productRef.update({
          'stock': FieldValue.increment(-value.quantity),
        });
      } catch (error) {
        await GlobalMethods.errorDialog(
          subtitle: error.toString(),
          context: ctx,
        );
      } finally {}
    });
  }

  Future<void> sendOrderInfo(
    Map<String, CartModel> carts,
    String userEmail,
    WidgetRef ref,
    double total,
    BuildContext ctx,
  ) async {
    var emailText = '';
    carts.forEach((key, cart) async {
      final getCurrProduct = ref.read(productsProvider.notifier).findProdById(
            cart.productId,
          );
      final price = (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          cart.quantity;
      emailText +=
          '${getCurrProduct.title} x${cart.quantity}  \$${price.toStringAsFixed(2)}<br>';
    });
    try {
      await FirebaseFirestore.instance.collection('emails').add({
        'to': userEmail,
        'message': {
          'subject': 'Your order completed',
          'html': 'Thank you for your order! Your order is listed below.'
              '<br><br>$emailText<br>'
              'Total: \$${total.toStringAsFixed(2)}'
        }
      });
    } catch (error) {
      await GlobalMethods.errorDialog(
        subtitle: error.toString(),
        context: ctx,
      );
    }
  }
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<OrderModel>>(
  (ref) => OrdersNotifier(),
);
