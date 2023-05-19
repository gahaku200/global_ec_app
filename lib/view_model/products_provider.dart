// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../model/product/product_model.dart';

class ProductsNotifier extends StateNotifier<List<ProductModel>> {
  ProductsNotifier() : super([]);

  List<ProductModel> get getOnSaleProducts {
    return state.where((product) => product.isOnSale).toList();
  }

  Future<void> fetchProducts() async {
    final array = <ProductModel>[];
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
      for (final element in productSnapshot.docs) {
        array.insert(
          0,
          ProductModel(
            id: element['id'] as String,
            title: element['title'] as String,
            imageUrl: element['imageUrl'] as String,
            productCategoryName: element['productCategoryName'] as String,
            price: element['price'] as double,
            salePrice: element['salePrice'] as double,
            isOnSale: element['isOnSale'] as bool,
            isPiece: element['isPiece'] as bool,
          ),
        );
      }
    });
    state = array;
  }

  ProductModel findProdById(String productId) {
    return state.firstWhere((product) => product.id == productId);
  }

  List<ProductModel> findByCategory(String categoryName) {
    final categoryList = state
        .where(
          (product) => product.productCategoryName
              .toLowerCase()
              .contains(categoryName.toLowerCase()),
        )
        .toList();
    return categoryList;
  }

  List<ProductModel> searchQuery(String searchText) {
    return state
        .where(
          (element) => element.title.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
  }
}

final productsProvider =
    StateNotifierProvider<ProductsNotifier, List<ProductModel>>(
  (ref) => ProductsNotifier(),
);
