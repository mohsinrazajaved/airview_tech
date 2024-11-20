import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6654986669520896/9825341597';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6654986669520896/8434093674';
    }
    throw UnsupportedError("Unsupported platform");
  }
}
