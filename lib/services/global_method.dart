// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../view/widgets/text_widget.dart';

class GlobalMethods {
  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    required Function fct,
    required BuildContext context,
  }) async {
    // ignore: inference_failure_on_function_invocation
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              Text(title),
            ],
          ),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: TextWidget(
                color: Colors.cyan,
                text: 'Cancel',
                textSize: 18,
              ),
            ),
            TextButton(
              onPressed: () {
                // ignore: avoid_dynamic_calls
                fct();
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: TextWidget(
                color: Colors.red,
                text: 'OK',
                textSize: 18,
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> errorDialog({
    required String subtitle,
    required BuildContext context,
  }) async {
    // ignore: inference_failure_on_function_invocation
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('An Error occured'),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: TextWidget(
                color: Colors.cyan,
                text: 'Ok',
                textSize: 18,
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> addToCart({
    required String productId,
    required int quantity,
    required BuildContext context,
  }) async {
    final user = authInstance.currentUser;
    final uid = user!.uid;
    final cartId = const Uuid().v4();
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'userCart': FieldValue.arrayUnion([
          {
            'cartId': cartId,
            'productId': productId,
            'quantity': quantity,
          }
        ])
      });
      await Fluttertoast.showToast(
        msg: 'Item has been added to your cart',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      await errorDialog(subtitle: error.toString(), context: context);
    }
  }

  static Future<void> addToWishlist({
    required String productId,
    required BuildContext context,
  }) async {
    final user = authInstance.currentUser;
    final uid = user!.uid;
    final wishlistId = const Uuid().v4();
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            'wishlistId': wishlistId,
            'productId': productId,
          }
        ])
      });
      await Fluttertoast.showToast(
        msg: 'Item has been added to your wishlist',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      await errorDialog(subtitle: error.toString(), context: context);
    }
  }
}
