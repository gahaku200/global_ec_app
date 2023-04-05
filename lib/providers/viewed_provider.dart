// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../models/viewed_model.dart';

class ViewedProdNotifier extends StateNotifier<Map<String, ViewedProdModel>> {
  ViewedProdNotifier() : super({});

  Map<String, ViewedProdModel> get getWishlistItems {
    return state;
  }

  void addProductToHistory({required String productId}) {
    state.putIfAbsent(
      productId,
      () => ViewedProdModel(
        id: DateTime.now().toString(),
        productId: productId,
      ),
    );
    changeState();
  }

  void clearHistory() {
    state = {};
  }

  void changeState() {
    final newState = state;
    state = {};
    state = newState;
  }
}

final viewedProdProvider =
    StateNotifierProvider<ViewedProdNotifier, Map<String, ViewedProdModel>>(
  (ref) => ViewedProdNotifier(),
);
