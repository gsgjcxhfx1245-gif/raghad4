import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import 'add_zekr_screen.dart';

class MyAzkarScreen extends StatelessWidget {
  final AppController appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my_azkar'.tr),
        backgroundColor: Colors.brown,
      ),
      body: Obx(() {
        if (appController.currentUser.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  'login_to_view'.tr,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); // العودة للشاشة السابقة
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('login'.tr),
                ),
              ],
            ),
          );
        }

        if (appController.azkarList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.list, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  'no_azkar'.tr,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text(
                  'click_to_add'.tr,
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => AddZekrScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('add_zekr'.tr),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: appController.azkarList.length,
          itemBuilder: (context, index) {
            final zekr = appController.azkarList[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: appController.getImportanceColor(zekr.importance),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${zekr.importance}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  zekr.content,
                  textAlign: TextAlign.right,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (zekr.category != null && zekr.category!.isNotEmpty)
                      Text(
                        'التصنيف: ${zekr.category}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    Text(
                      '${zekr.createdAt.day}/${zekr.createdAt.month}/${zekr.createdAt.year}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (zekr.imagePath != null)
                      Icon(Icons.photo, color: Colors.brown),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteDialog(index);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddZekrScreen());
        },
        backgroundColor: Colors.brown,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showDeleteDialog(int index) {
    Get.dialog(
      AlertDialog(
        title: Text('تأكيد الحذف'.tr),
        content: Text('هل أنت متأكد من حذف هذا الذكر؟'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              appController.deleteZekr(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }
}