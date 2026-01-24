import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/translations.dart';
import 'splash_screen.dart';
import 'controllers/auth_controller.dart'; // ← أضف هذا
import 'controllers/language_controller.dart'; // ← أضف هذا

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ← أضف هذا الجزء لتسجيل الـ Controllers
    Get.put(AuthController());
    Get.put(LanguageController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('ar'),
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Tajawal',
      ),
      home: const SplashScreen(),
    );
  }
}