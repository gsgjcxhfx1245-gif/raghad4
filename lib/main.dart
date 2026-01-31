import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:raghad4/splash_screen.dart';
import 'controllers/app_controller.dart';
import 'controllers/language_controller.dart';
import 'utils/translations.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // تهيئة جميع الـ Controllers
    Get.put(LanguageController());
    Get.put(AppController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'app_name'.tr,
      translations: AppTranslations(),
      locale: Get.find<LanguageController>().currentLocale.value,
      fallbackLocale: Locale('ar'),
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Tajawal',
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}