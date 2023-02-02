// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_flavor/flutter_flavor.dart';

// Project imports:
import 'app.dart';
import 'flavors.dart';

void main() {
  FlavorConfig(
    name: 'PROD',
    color: Colors.blue,
    location: BannerLocation.bottomStart,
    variables: {
      'baseUrl': 'https://local-prodapp.com/api',
    },
  );
  F.appFlavor = Flavor.PROD;
  runApp(const App());
}
