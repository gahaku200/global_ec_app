// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import '../../services/utils.dart';
import '../../view_model/dark_theme_provider.dart';
import 'text_widget.dart';

class EmptyScreen extends HookConsumerWidget {
  const EmptyScreen({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });
  final String imagePath;
  final String title;
  final String subtitle;
  final String buttonText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utils = Utils(context);
    final color = ref.watch(utils.getTheme);
    final size = utils.getScreenSize;
    final isDark = ref.watch(themeState);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                imagePath,
                width: double.infinity,
                height: size.height * 0.4,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Whoops!',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: title,
                color: Colors.cyan,
                textSize: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              TextWidget(
                text: subtitle,
                color: Colors.cyan,
                textSize: 20,
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: color,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: color,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                ),
                onPressed: () {
                  context.go('/FeedsScreenState');
                },
                child: TextWidget(
                  text: buttonText,
                  textSize: 20,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                  isTitle: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
