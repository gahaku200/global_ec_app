// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../model/product/product_model.dart';
import '../../services/utils.dart';
import '../../view_model/products_provider.dart';
import '../widgets/back_widget.dart';
import '../widgets/empty_products_widget.dart';
import '../widgets/product_widget.dart';
import '../widgets/text_widget.dart';

final listProdcutSearchProvider = StateProvider<List<ProductModel>>((_) => []);

class CategoryScreen extends HookConsumerWidget {
  const CategoryScreen({
    super.key,
    required this.catName,
  });

  final String? catName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;
    final searchTextController = useTextEditingController();
    final searchTextFocusNode = useFocusNode();
    final productByCat =
        ref.read(productsProvider.notifier).findByCategory(catName!);
    final listProdcutSearch = ref.watch(listProdcutSearchProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: TextWidget(
          text: catName!,
          color: color,
          textSize: 20,
          isTitle: true,
        ),
      ),
      body: productByCat.isEmpty
          ? const EmptyProdWidget(
              text: 'No products belong to this category',
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      height: kBottomNavigationBarHeight,
                      child: TextField(
                        focusNode: searchTextFocusNode,
                        controller: searchTextController,
                        onChanged: (value) {
                          ref.read(listProdcutSearchProvider.notifier).state =
                              ref
                                  .read(productsProvider.notifier)
                                  .searchQuery(value);
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.greenAccent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.greenAccent,
                            ),
                          ),
                          hintText: "What's in your mind",
                          prefixIcon: const Icon(Icons.search),
                          suffix: IconButton(
                            onPressed: () {
                              searchTextController.clear();
                              searchTextFocusNode.unfocus();
                            },
                            icon: Icon(
                              Icons.close,
                              color: searchTextFocusNode.hasFocus
                                  ? Colors.red
                                  : color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  searchTextController.text.isNotEmpty &&
                          listProdcutSearch.isEmpty
                      ? const EmptyProdWidget(
                          text: 'No products found, please try another keyword',
                        )
                      : GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          padding: EdgeInsets.zero,
                          // crossAxisSpacing: 10,
                          childAspectRatio: size.width / (size.height * 0.61),
                          children: List.generate(
                            searchTextController.text.isNotEmpty
                                ? listProdcutSearch.length
                                : productByCat.length,
                            (index) {
                              return ProductWidget(
                                productModel:
                                    searchTextController.text.isNotEmpty
                                        ? listProdcutSearch[index]
                                        : productByCat[index],
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
