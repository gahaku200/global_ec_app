// ignore_for_file: constant_identifier_names

enum Flavor {
  DEV,
  STG,
  PROD,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.DEV:
        return 'Japanese Market(dev)';
      case Flavor.STG:
        return 'Japanese Market(stg)';
      case Flavor.PROD:
        return 'Japanese Market';
      default:
        return 'title';
    }
  }
}
