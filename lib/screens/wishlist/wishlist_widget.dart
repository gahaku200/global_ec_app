// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../services/utils.dart';
import '../../widgets/heart_btn.dart';
import '../../widgets/text_widget.dart';

class WishlistWidget extends HookConsumerWidget {
  const WishlistWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {
          context.go('/ProductDetails');
        },
        child: Container(
          height: size.height * 0.2,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8),
                width: size.width * 0.2,
                height: size.width * 0.25,
                child: FancyShimmerImage(
                  imageUrl: 'https://i.ibb.co/F0s3FHQ/Apricots.png',
                ),
              ),
              Column(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            IconlyLight.bag2,
                            color: color,
                          ),
                        ),
                        const HeartBTN(),
                      ],
                    ),
                  ),
                  Flexible(
                    child: TextWidget(
                      text: 'Title',
                      color: color,
                      textSize: 20,
                      maxLines: 2,
                      isTitle: true,
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextWidget(
                    text: '\$2.59',
                    color: color,
                    textSize: 18,
                    maxLines: 1,
                    isTitle: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
