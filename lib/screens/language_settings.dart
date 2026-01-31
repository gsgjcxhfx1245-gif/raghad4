import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/language_controller.dart';

class LanguageSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LanguageController languageController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('language_settings'.tr),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'select_language'.tr,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            SizedBox(height: 20),
            Obx(() => Card(
              elevation: languageController.isArabic.value ? 4 : 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: languageController.isArabic.value
                      ? Colors.brown
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.brown[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'ع',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'العربية',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Arabic'),
                trailing: languageController.isArabic.value
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () {
                  if (!languageController.isArabic.value) {
                    languageController.changeLanguage('ar');
                  }
                },
              ),
            )),
            SizedBox(height: 15),
            Obx(() => Card(
              elevation: !languageController.isArabic.value ? 4 : 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: !languageController.isArabic.value
                      ? Colors.brown
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'EN',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'English',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('الإنجليزية'),
                trailing: !languageController.isArabic.value
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () {
                  if (languageController.isArabic.value) {
                    languageController.changeLanguage('en');
                  }
                },
              ),
            )),
            SizedBox(height: 30),
            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ملاحظة:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'سيتم تطبيق تغيير اللغة على جميع شاشات التطبيق.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  languageController.resetToDefault();
                },
                icon: Icon(Icons.restart_alt),
                label: Text('إعادة تعيين إلى الافتراضي'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.brown,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}