// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../model/category/category_model.dart';

class CategoryNotifier extends StateNotifier<List<CategoryModel>> {
  CategoryNotifier() : super([]);

  Future<void> fetchCategory() async {
    await FirebaseFirestore.instance
        .collection('categories')
        .orderBy('id', descending: true)
        .get()
        .then((QuerySnapshot categoriesSnapshot) {
      state = [];
      for (final element in categoriesSnapshot.docs) {
        state.insert(
          0,
          CategoryModel(
            id: element['id'] as String,
            catText: element['catText'] as String,
            imgPath: element['imgPath'] as String,
          ),
        );
      }
    });
  }
}

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, List<CategoryModel>>(
  (ref) => CategoryNotifier(),
);
