// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../services/utils.dart';
import '../widgets/categories_widget.dart';
import '../widgets/text_widget.dart';

class CategoriesScreen extends HookConsumerWidget {
  CategoriesScreen({super.key});
  final List<Color> gridColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];
  final List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': '',
      'catText': 'Fruits',
    },
    {
      'imgPath': '',
      'catText': 'Vegetables',
    },
    {
      'imgPath': '',
      'catText': 'Herbs',
    },
    {
      'imgPath': '',
      'catText': 'Nuts',
    },
    {
      'imgPath': '',
      'catText': 'Spices',
    },
    {
      'imgPath': '',
      'catText': 'Grains',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TextWidget(
          text: 'Categories',
          color: color,
          textSize: 24,
          isTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 240 / 250,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(
            6,
            (index) {
              return CategoriesWidget(
                catText: catInfo[index]['catText'] as String,
                imgPath: catInfo[index]['imgPath'] as String,
                passedColor: gridColors[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
