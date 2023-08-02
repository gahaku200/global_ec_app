/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

// Flutter imports:
import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/SUGOI_logo.png
  AssetGenImage get sUGOILogo =>
      const AssetGenImage('assets/images/SUGOI_logo.png');

  /// File path: assets/images/SUGOI_logo_header.png
  AssetGenImage get sUGOILogoHeader =>
      const AssetGenImage('assets/images/SUGOI_logo_header.png');

  /// File path: assets/images/SUGOI_logo_splash.png
  AssetGenImage get sUGOILogoSplash =>
      const AssetGenImage('assets/images/SUGOI_logo_splash.png');

  $AssetsImagesOffersGen get offers => const $AssetsImagesOffersGen();

  /// List of all assets
  List<AssetGenImage> get values =>
      [sUGOILogo, sUGOILogoHeader, sUGOILogoSplash];
}

class $AssetsImagesOffersGen {
  const $AssetsImagesOffersGen();

  /// File path: assets/images/offers/Google.png
  AssetGenImage get google =>
      const AssetGenImage('assets/images/offers/Google.png');

  /// File path: assets/images/offers/calpis.jpg
  AssetGenImage get calpis =>
      const AssetGenImage('assets/images/offers/calpis.jpg');

  /// File path: assets/images/offers/matcha.jpg
  AssetGenImage get matcha =>
      const AssetGenImage('assets/images/offers/matcha.jpg');

  /// File path: assets/images/offers/nihonshu-sparkling.jpg
  AssetGenImage get nihonshuSparkling =>
      const AssetGenImage('assets/images/offers/nihonshu-sparkling.jpg');

  /// File path: assets/images/offers/origami.jpg
  AssetGenImage get origami =>
      const AssetGenImage('assets/images/offers/origami.jpg');

  /// File path: assets/images/offers/sensu.jpg
  AssetGenImage get sensu =>
      const AssetGenImage('assets/images/offers/sensu.jpg');

  /// File path: assets/images/offers/shokuhin-sample.jpg
  AssetGenImage get shokuhinSample =>
      const AssetGenImage('assets/images/offers/shokuhin-sample.jpg');

  /// File path: assets/images/offers/shopping-cart.jpeg
  AssetGenImage get shoppingCart =>
      const AssetGenImage('assets/images/offers/shopping-cart.jpeg');

  /// File path: assets/images/offers/tenugui.jpg
  AssetGenImage get tenugui =>
      const AssetGenImage('assets/images/offers/tenugui.jpg');

  /// File path: assets/images/offers/wagasa.jpg
  AssetGenImage get wagasa =>
      const AssetGenImage('assets/images/offers/wagasa.jpg');

  /// File path: assets/images/offers/wagashi.jpg
  AssetGenImage get wagashi =>
      const AssetGenImage('assets/images/offers/wagashi.jpg');

  /// List of all assets
  List<AssetGenImage> get values => [
        google,
        calpis,
        matcha,
        nihonshuSparkling,
        origami,
        sensu,
        shokuhinSample,
        shoppingCart,
        tenugui,
        wagasa,
        wagashi
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
