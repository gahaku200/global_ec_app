// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoadingManager extends HookConsumerWidget {
  const LoadingManager({
    super.key,
    required this.isLoading,
    required this.child,
  });
  final bool isLoading;
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        child,
        isLoading
            ? Container(
                color: Colors.black.withOpacity(0.7),
              )
            : Container(),
        isLoading
            ? const Center(
                child: SpinKitFadingFour(
                  color: Colors.white,
                ),
              )
            : Container(),
      ],
    );
  }
}
