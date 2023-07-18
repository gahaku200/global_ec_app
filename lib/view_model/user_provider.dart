// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../model/user/user_model.dart';
import '../services/global_method.dart';
import '../view/fetch_screen.dart';

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier()
      : super(
          UserModel(
            name: '',
            email: '',
            address: '',
          ),
        );

  Future<void> setName(String name) async {
    state = state.copyWith(name: name);
  }

  // void setEmail(String email) {
  //   state = state.copyWith(email: email);
  // }

  // void setAddress(String address) {
  //   state = state.copyWith(address: address);
  // }

  Future<void> getUserData(BuildContext context) async {
    final user = authInstance.currentUser;
    if (user == null) {
      return;
    }
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final updatedUser = state.copyWith(
        name: userDoc.get('name') as String,
        email: userDoc.get('email') as String,
        address: userDoc.get('shipping-address') as String,
        sex: userDoc.data()!.containsKey('sex')
            ? userDoc.get('sex') as int
            : state.sex,
        birthday: userDoc.data()!.containsKey('birthday')
            ? userDoc.get('birthday') as String
            : state.birthday,
        country: userDoc.data()!.containsKey('country')
            ? userDoc.get('country') as String
            : state.country,
        zipcode: userDoc.data()!.containsKey('zipcode')
            ? userDoc.get('zipcode') as String
            : state.zipcode,
        phoneNumber: userDoc.data()!.containsKey('phoneNumber')
            ? userDoc.get('phoneNumber') as String
            : state.phoneNumber,
        stripeCustomerId: userDoc.data()!.containsKey('stripeCustomerId')
            ? userDoc.get('stripeCustomerId') as String
            : state.stripeCustomerId,
      );
      state = updatedUser;
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      await GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

  Future<void> submitFormOnRegister(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    String emailTextControllerText,
    String passTextControllerText,
    String fullNameControllerText,
    String addressTextControllerText,
  ) async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      formKey.currentState!.save();
      try {
        await authInstance.createUserWithEmailAndPassword(
          email: emailTextControllerText.toLowerCase().trim(),
          password: passTextControllerText.trim(),
        );
        final user = authInstance.currentUser;
        final uid = user!.uid;
        await user.updateDisplayName(fullNameControllerText);
        await user.reload();
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'id': uid,
          'name': fullNameControllerText,
          'email': emailTextControllerText.toLowerCase(),
          'shipping-address': addressTextControllerText,
          // ignore: inference_failure_on_collection_literal
          'userWish': [],
          // ignore: inference_failure_on_collection_literal
          'userCart': [],
          'createdAt': Timestamp.now(),
        });
        ref.read(isFirstProvider.notifier).state = true;
        context.go('/FetchScreen');
      } on FirebaseException catch (error) {
        await GlobalMethods.errorDialog(
          subtitle: '${error.message}',
          context: context,
        );
        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        await GlobalMethods.errorDialog(
          subtitle: '$error',
          context: context,
        );
      } finally {}
    }
  }

  Future<void> submitFormOnLogin(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    String emailTextControllerText,
    String passTextControllerText,
  ) async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      formKey.currentState!.save();
      try {
        await authInstance.signInWithEmailAndPassword(
          email: emailTextControllerText.toLowerCase().trim(),
          password: passTextControllerText.trim(),
        );
        context.go('/FetchScreen');
      } on FirebaseException catch (error) {
        await GlobalMethods.errorDialog(
          subtitle: '${error.message}',
          context: context,
        );
        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        await GlobalMethods.errorDialog(
          subtitle: '$error',
          context: context,
        );
      } finally {}
    }
  }

  Future<void> updateUserName(String nameTextControllerText) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': nameTextControllerText,
    });
    final updatedUser = state.copyWith(name: nameTextControllerText);
    state = updatedUser;
  }

  Future<void> updateUserEmail(String emailTextControllerText) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'email': emailTextControllerText,
    });
    final updatedUser = state.copyWith(email: emailTextControllerText);
    state = updatedUser;
  }

  Future<void> updateUserAddress(String addressTextControllerText) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'shipping-address': addressTextControllerText,
    });
    final updatedUser = state.copyWith(address: addressTextControllerText);
    state = updatedUser;
  }

  Future<void> updateUserSex(int sex) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'sex': sex,
    });
    final updatedUser = state.copyWith(sex: sex);
    state = updatedUser;
  }

  Future<void> updateUserBirthday(String birthday) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'birthday': birthday,
    });
    final updatedUser = state.copyWith(birthday: birthday);
    state = updatedUser;
  }

  Future<void> updateUserCountry(String code) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'country': code,
    });
    final updatedUser = state.copyWith(country: code);
    state = updatedUser;
  }

  Future<void> updateUserZipcode(String zipcode) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'zipcode': zipcode,
    });
    final updatedUser = state.copyWith(zipcode: zipcode);
    state = updatedUser;
  }

  Future<void> updateUserPhoneNumber(String phoneNumber) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'phoneNumber': phoneNumber,
    });
    final updatedUser = state.copyWith(phoneNumber: phoneNumber);
    state = updatedUser;
  }

  Future<void> registerUserStripeCustomerId(String stripeCustomerId) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'stripeCustomerId': stripeCustomerId,
    });
    final updatedUser = state.copyWith(stripeCustomerId: stripeCustomerId);
    state = updatedUser;
  }

  bool checkUserInfoEnough() {
    if (state.sex == -1 ||
        state.birthday == '' ||
        state.country == '' ||
        state.phoneNumber == '') {
      return false;
    } else {
      return true;
    }
  }

  void signOut() {
    state = UserModel(
      name: '',
      email: '',
      address: '',
    );
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel>(
  (ref) => UserNotifier(),
);
