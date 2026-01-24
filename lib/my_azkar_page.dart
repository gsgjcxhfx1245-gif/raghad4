import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_zekr_page.dart';
import 'controllers/auth_controller.dart';
import 'controllers/language_controller.dart';
import 'login_screen.dart';

class MyAzkarPage extends StatefulWidget {
  const MyAzkarPage({super.key});

  @override
  State<MyAzkarPage> createState() => _MyAzkarPageState();
}

class _MyAzkarPageState extends State<MyAzkarPage> {
  final AuthController authController = Get.find();
  final LanguageController languageController = Get.find();

  void editZekr(int index) {
    if (authController.currentUser.value == null) return;

    TextEditingController controller = TextEditingController(
      text: authController.currentUser.value!.myPrivateAzkar[index],
    );

    Get.dialog(
      AlertDialog(
        title: Text('edit_zekr'.tr),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'write_zekr_here'.tr,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                authController.currentUser.value!.myPrivateAzkar[index] = controller.text;
                authController.currentUser.refresh();
                Get.back();
                Get.snackbar('success'.tr, 'edit_success'.tr);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            child: Text('save'.tr),
          ),
        ],
      ),
    );
  }

  void deleteZekr(int index) {
    if (authController.currentUser.value == null) return;

    Get.dialog(
      AlertDialog(
        title: Text('confirm_delete'.tr),
        content: Text('delete_message'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              authController.currentUser.value!.myPrivateAzkar.removeAt(index);
              authController.currentUser.refresh();
              Get.back();
              Get.snackbar('success'.tr, 'delete_success'.tr);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('my_azkar'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              languageController.toggleLanguage();
            },
          ),
          Obx(() => authController.currentUser.value != null
              ? Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${authController.currentUser.value!.myPrivateAzkar.length}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          )
              : const SizedBox()),
        ],
      ),
      body: Obx(() {
        if (authController.currentUser.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_off, size: 80, color: Colors.grey),
                const SizedBox(height: 20),
                Text(
                  'login_to_view'.tr,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => const LoginScreen());
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

        if (authController.currentUser.value!.myPrivateAzkar.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.list, size: 80, color: Colors.grey),
                const SizedBox(height: 20),
                Text(
                  'no_azkar'.tr,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  'click_to_add'.tr,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: authController.currentUser.value!.myPrivateAzkar.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.brown[100],
                  child: Text('${index + 1}'),
                ),
                title: Text(authController.currentUser.value!.myPrivateAzkar[index]),
                subtitle: Text(
                  '${(authController.currentUser.value!.myPrivateAzkar[index].length)} ${'char_count'.tr}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => editZekr(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteZekr(index),
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
          Get.to(() => AddZekrPage())?.then((_) {
            setState(() {});
          });
        },
        backgroundColor: Colors.brown,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}