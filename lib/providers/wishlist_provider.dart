// Package imports:
// ignore_for_file: avoid_dynamic_calls

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../models/wishlist_model.dart';

class WishlistNotifier extends StateNotifier<Map<String, WishlistModel>> {
  WishlistNotifier() : super({});

  Map<String, WishlistModel> get getWishlistItems {
    return state;
  }

  final userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> fetchWishlist() async {
    final user = authInstance.currentUser;
    final DocumentSnapshot userDoc = await userCollection.doc(user!.uid).get();
    final leng = int.parse(userDoc.get('userWish').length.toString());
    for (var i = 0; i < leng; i++) {
      state.putIfAbsent(
        userDoc.get('userWish')[i]['productId'].toString(),
        () => WishlistModel(
          id: userDoc.get('userWish')[i]['wishlistId'].toString(),
          productId: userDoc.get('userWish')[i]['productId'].toString(),
        ),
      );
    }
    changeState();
  }

  Future<void> removeOneItem({
    required String wishlistId,
    required String productId,
  }) async {
    final user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userWish': FieldValue.arrayRemove([
        {
          'wishlistId': wishlistId,
          'productId': productId,
        }
      ])
    });
    state.remove(productId);
    await fetchWishlist();
    changeState();
  }

  Future<void> clearOnlineWishlist() async {
    final user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update({
      'userWish': [],
    });
    state = {};
  }

  void clearLocalWishlist() {
    state = {};
  }

  void changeState() {
    final newState = state;
    state = {};
    state = newState;
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, Map<String, WishlistModel>>(
  (ref) => WishlistNotifier(),
);
