// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../view_model/dark_theme_provider.dart';
import 'text_widget.dart';

class CategoriesWidget extends HookConsumerWidget {
  const CategoriesWidget({
    super.key,
    required this.catText,
    required this.imgPath,
  });
  final String catText;
  final String imgPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = ref.watch(themeState);
    final color = isDark ? Colors.white : Colors.black;

    return InkWell(
      onTap: () {
        context.go('/CategoryScreen/$catText');
      },
      child: Column(
        children: [
          SizedBox(
            height: screenWidth * 0.35,
            width: screenWidth * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imgPath,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextWidget(
            text: catText,
            color: color,
            textSize: 16,
            isTitle: true,
          ),
        ],
      ),
    );
  }
}
