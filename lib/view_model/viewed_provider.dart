// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../model/viewed/viewed_model.dart';

class ViewedProdNotifier extends StateNotifier<Map<String, ViewedProdModel>> {
  ViewedProdNotifier() : super({});

  void addProductToHistory({required String productId}) {
    state.putIfAbsent(
      productId,
      () => ViewedProdModel(
        id: DateTime.now().toString(),
        productId: productId,
      ),
    );
  }

  void clearHistory() {
    state = {};
  }
}

final viewedProdProvider =
    StateNotifierProvider<ViewedProdNotifier, Map<String, ViewedProdModel>>(
  (ref) => ViewedProdNotifier(),
);
