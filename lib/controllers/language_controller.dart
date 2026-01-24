import 'package:flutter/material.dart';  // ← أضف هذا
import 'package:get/get.dart';

class LanguageController extends GetxController {
  RxBool isArabic = true.obs;

  void toggleLanguage() {
    isArabic.value = !isArabic.value;
    if (isArabic.value) {
      Get.updateLocale(const Locale('ar'));  // ← أضف const
    } else {
      Get.updateLocale(const Locale('en'));  // ← أضف const
    }
  }}