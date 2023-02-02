// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_flavor/flutter_flavor.dart';

// Project imports:
import 'app.dart';
import 'flavors.dart';

void main() {
  FlavorConfig(
    name: 'DEV',
    location: BannerLocation.bottomStart,
    variables: {
      'baseUrl': 'https://local-devapp.com/api',
    },
  );
  F.appFlavor = Flavor.DEV;
  runApp(const App());
}
