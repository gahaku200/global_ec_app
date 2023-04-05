// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../provider/dark_theme_provider.dart';
import 'text_widget.dart';

class CategoriesWidget extends HookConsumerWidget {
  const CategoriesWidget({
    super.key,
    required this.catText,
    required this.imgPath,
    required this.passedColor,
  });
  final String catText;
  final String imgPath;
  final Color passedColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = ref.watch(themeState);
    final color = isDark ? Colors.white : Colors.black;

    return InkWell(
      onTap: () {
        context.go('/CategoryScreen/$catText');
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: passedColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: passedColor.withOpacity(0.7),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: screenWidth * 0.3,
              width: screenWidth * 0.3,
              decoration: const BoxDecoration(
                  // image: DecorationImage(
                  //   image: AssetImage(imgPath,),
                  //   fit: BoxFit.fill,
                  // ),
                  ),
            ),
            TextWidget(
              text: catText,
              color: color,
              textSize: 20,
              isTitle: true,
            ),
          ],
        ),
      ),
    );
  }
}
