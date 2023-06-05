// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../services/utils.dart';
import '../../view_model/category_provider.dart';
import '../widgets/categories_widget.dart';
import '../widgets/text_widget.dart';

class CategoriesScreen extends HookConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final allCategories = ref.watch(categoryProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: TextWidget(
          text: 'Categories',
          color: color,
          textSize: 24,
          isTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 245 / 250,
          crossAxisSpacing: 10,
          mainAxisSpacing: 2,
          children: List.generate(
            allCategories.length,
            (index) {
              return CategoriesWidget(
                catText: allCategories[index].catText,
                imgPath: allCategories[index].imgPath,
              );
            },
          ),
        ),
      ),
    );
  }
}
