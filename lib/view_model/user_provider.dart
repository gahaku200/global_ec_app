// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../model/user/user_model.dart';
import '../services/global_method.dart';

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier()
      : super(
          UserModel(
            name: '',
            email: '',
            address: '',
          ),
        );

  Future<void> getUserData(BuildContext context) async {
    final user = authInstance.currentUser;
    if (user == null) {
      return;
    }
    try {
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final updatedUser = state.copyWith(
        name: userDoc.get('name') as String,
        email: userDoc.get('email') as String,
        address: userDoc.get('shipping-address') as String,
      );
      state = updatedUser;
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      await GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

  Future<void> updateUserAddress(String addressTextControllerText) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'shipping-address': addressTextControllerText,
    });
    final updatedUser = state.copyWith(address: addressTextControllerText);
    state = updatedUser;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel>(
  (ref) => UserNotifier(),
);
