import 'package:airview_tech/localization/locales/en-US.dart';
import 'package:airview_tech/localization/locales/fr-CA.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "en_US": enUS,
        "fr_CA": frCA,
      };

  static getEnglishUSLocale() => const Locale('en', 'US');

  static getFrenchLocale() => const Locale('fr', 'CA');
}
