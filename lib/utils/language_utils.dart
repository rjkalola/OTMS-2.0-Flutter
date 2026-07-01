import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLanguage {
  final String localeKey;
  final String flagAsset;
  final String titleKey;

  const AppLanguage({
    required this.localeKey,
    required this.flagAsset,
    required this.titleKey,
  });

  Locale get locale {
    final parts = localeKey.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : '');
  }
}

class LanguageUtils {
  LanguageUtils._();

  static const String defaultLocaleKey = 'en_US';

  static const List<AppLanguage> languages = [
    AppLanguage(
      localeKey: 'en_US',
      flagAsset: Drawable.flagEnglish,
      titleKey: 'english',
    ),
    AppLanguage(
      localeKey: 'uk_UA',
      flagAsset: Drawable.flagUkrainian,
      titleKey: 'ukrainian',
    ),
    AppLanguage(
      localeKey: 'ru_RU',
      flagAsset: Drawable.flagRussian,
      titleKey: 'russian',
    ),
  ];

  static AppLanguage getLanguageByKey(String localeKey) {
    return languages.firstWhere(
      (lang) => lang.localeKey == localeKey,
      orElse: () => languages.first,
    );
  }

  static Locale localeFromKey(String localeKey) {
    return getLanguageByKey(localeKey).locale;
  }

  static Locale getSavedLocale() {
    return localeFromKey(Get.find<AppStorage>().getAppLanguage());
  }

  static void applyLocale(String localeKey) {
    Get.find<AppStorage>().setAppLanguage(localeKey);
    Get.updateLocale(localeFromKey(localeKey));
  }

  static void resetToDefault() {
    Get.find<AppStorage>().removeData(
      AppConstants.sharedPreferenceKey.appLanguage,
    );
    Get.updateLocale(localeFromKey(defaultLocaleKey));
  }
}
