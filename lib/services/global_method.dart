// Flutter imports:
// ignore_for_file: avoid_redundant_argument_values

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
  static const Color defaultTextColorBlack = Color.fromRGBO(0, 0, 0, 0.85);
  static const Color defaultTextColorWhite = Color.fromRGBO(255, 255, 255, 0.9);

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
      await FirebaseFirestore.instance.collection('users').doc(uid).update(
        {
          'userCart': FieldValue.arrayUnion([
            {
              'cartId': cartId,
              'productId': productId,
              'quantity': quantity,
            }
          ]),
        },
      );
      final fToast = FToast();
      await showToast(fToast, context, 'Item has been added to your cart');
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
      await FirebaseFirestore.instance.collection('users').doc(uid).update(
        {
          'userWish': FieldValue.arrayUnion([
            {
              'wishlistId': wishlistId,
              'productId': productId,
            }
          ]),
        },
      );
      final fToast = FToast();
      await showToast(fToast, context, 'Item has been added to your wishlist');
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      await errorDialog(subtitle: error.toString(), context: context);
    }
  }

  static Future<void> showToast(
    FToast fToast,
    BuildContext context,
    String messsage, {
    Color backgroundColor = defaultTextColorWhite,
    Color textColor = defaultTextColorBlack,
  }) async {
    fToast
      ..removeCustomToast()
      ..init(context)
      ..showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: backgroundColor,
          ),
          child: Text(
            messsage,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
        toastDuration: const Duration(seconds: 3),
        positionedToastBuilder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 60,
                child: child,
              ),
            ],
          );
        },
      );
  }
}
