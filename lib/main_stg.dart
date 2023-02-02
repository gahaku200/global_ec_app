// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_flavor/flutter_flavor.dart';

// Project imports:
import 'app.dart';
import 'flavors.dart';

void main() {
  FlavorConfig(
    name: 'STG',
    color: Colors.yellow,
    location: BannerLocation.bottomStart,
    variables: {
      'baseUrl': 'https://local-stgapp.com/api',
    },
  );
  F.appFlavor = Flavor.STG;
  runApp(const App());
}
