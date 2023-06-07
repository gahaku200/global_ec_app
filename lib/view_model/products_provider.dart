// Package imports:
// ignore_for_file: avoid_dynamic_calls

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
        final leng = int.parse(element['imageUrlList'].length.toString());
        final imageUrlList = <String>[];
        for (var i = 0; i < leng; i++) {
          imageUrlList.add(element['imageUrlList'][i] as String);
        }
        array.insert(
          0,
          ProductModel(
            id: element['id'] as String,
            title: element['title'] as String,
            imageUrlList: imageUrlList,
            productCategoryName: element['productCategoryName'] as String,
            price: element['price'] as double,
            salePrice: element['salePrice'] as double,
            isOnSale: element['isOnSale'] as bool,
            isPiece: element['isPiece'] as bool,
            description: element['description'] as String,
            stock: element['stock'] as int,
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
