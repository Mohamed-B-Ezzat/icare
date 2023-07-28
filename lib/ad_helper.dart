import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7278285712256233/3191716144';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7278285712256233/3191716144';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7278285712256233~5718739349";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7278285712256233~5718739349";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get appopenAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7278285712256233/8209853508";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7278285712256233/8209853508";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}