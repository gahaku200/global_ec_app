// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:

class BottomBarProvider extends StateNotifier<int> {
  BottomBarProvider() : super(0);
  // ignore: use_setters_to_change_properties
  void setBtmBarState(int index) {
    state = index;
  }
}

final btmBarState = StateNotifierProvider<BottomBarProvider, int>(
  (ref) => BottomBarProvider(),
);
