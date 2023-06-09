// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../services/utils.dart';
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
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;

    return InkWell(
      onTap: () {
        context.go('/CategoryScreen/$catText');
      },
      child: Column(
        children: [
          SizedBox(
            height: size.width * 0.35,
            width: size.width * 0.4,
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
