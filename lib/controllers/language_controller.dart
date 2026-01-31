import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final RxBool isArabic = true.obs;
  final Rx<Locale> currentLocale = Locale('ar').obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    final savedLang = box.read('app_language');
    if (savedLang != null) {
      isArabic.value = savedLang == 'ar';
      currentLocale.value = Locale(savedLang);
      Get.updateLocale(currentLocale.value);
    } else {
      isArabic.value = true;
      currentLocale.value = Locale('ar');
      Get.updateLocale(Locale('ar'));
    }
  }

  void changeLanguage(String languageCode) {
    if (languageCode == 'ar') {
      isArabic.value = true;
      currentLocale.value = Locale('ar');
      box.write('app_language', 'ar');
    } else {
      isArabic.value = false;
      currentLocale.value = Locale('en');
      box.write('app_language', 'en');
    }

    Get.updateLocale(currentLocale.value);

    Get.snackbar(
      'language_changed'.tr,
      isArabic.value ? 'تم التغيير إلى العربية' : 'Changed to English',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void toggleLanguage() {
    if (isArabic.value) {
      changeLanguage('en');
    } else {
      changeLanguage('ar');
    }
  }

  String get currentLanguageName {
    return isArabic.value ? 'العربية' : 'English';
  }

  String get currentLanguageCode {
    return isArabic.value ? 'ar' : 'en';
  }

  void resetToDefault() {
    changeLanguage('ar');
  }

  bool get isArabicLanguage {
    return currentLocale.value.languageCode == 'ar';
  }
}