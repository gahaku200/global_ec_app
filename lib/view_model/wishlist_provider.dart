// Package imports:
// ignore_for_file: avoid_dynamic_calls

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../consts/firebase_consts.dart';
import '../model/wishlist/wishlist_model.dart';

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
        userDoc['userWish'][i]['productId'] as String,
        () => WishlistModel(
          id: userDoc['userWish'][i]['wishlistId'] as String,
          productId: userDoc['userWish'][i]['productId'] as String,
        ),
      );
    }
    state = {...state};
  }

  Future<void> removeOneItem({
    required String wishlistId,
    required String productId,
  }) async {
    final user = authInstance.currentUser;
    await userCollection.doc(user!.uid).update(
      {
        'userWish': FieldValue.arrayRemove([
          {
            'wishlistId': wishlistId,
            'productId': productId,
          }
        ])
      },
    );
    state.remove(productId);
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
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, Map<String, WishlistModel>>(
  (ref) => WishlistNotifier(),
);
