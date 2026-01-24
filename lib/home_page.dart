import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_zekr_page.dart';
import 'my_azkar_page.dart';
import 'login_screen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/language_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AuthController authController = Get.find();
  final LanguageController languageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('app_name'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              languageController.toggleLanguage();
            },
          ),
        ],
      ),
      drawer: AppDrawer(authController: authController),
      body: Obx(() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (authController.currentUser.value != null) ...[
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.brown[100],
              child: Text(
                authController.currentUser.value!.profileImage,
                style: const TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${'welcome'.tr} ${authController.currentUser.value!.name}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'in_fortress'.tr,
              style: TextStyle(
                fontSize: 18,
                color: Colors.brown[600],
              ),
            ),
          ] else ...[
            const Icon(Icons.mosque, size: 60, color: Colors.brown),
            const SizedBox(height: 20),
            Text(
              'welcome_to_fortress'.tr,
              style: const TextStyle(fontSize: 18, color: Colors.brown),
            ),
          ],
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              authController.currentUser.value != null
                  ? '${'you_have'.tr} ${authController.currentUser.value!.myPrivateAzkar.length} ${'private_zekr'.tr}'
                  : 'login_for_azkar'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown[700],
              ),
            ),
          ),
          const SizedBox(height: 30),
          if (authController.currentUser.value == null)
            ElevatedButton(
              onPressed: () {
                Get.offAll(() => LoginScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
              ),
              child: Text('login'.tr),
            ),
        ],
      )),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final AuthController authController;

  const AppDrawer({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.brown),
            child: Center(
              child: Text(
                'menu'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Obx(() => authController.currentUser.value != null
              ? UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.brown),
            accountName: Text(authController.currentUser.value!.name),
            accountEmail: Text(authController.currentUser.value!.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.brown[100],
              child: Text(authController.currentUser.value!.profileImage),
            ),
          )
              : const SizedBox()),
          ListTile(
            leading: const Icon(Icons.add, color: Colors.brown),
            title: Text('add_zekr'.tr),
            onTap: () {
              Get.to(() => AddZekrPage());
            },
          ),
          Obx(() => authController.currentUser.value != null
              ? ListTile(
            leading: const Icon(Icons.list, color: Colors.brown),
            title: Text('my_azkar'.tr),
            onTap: () {
              Get.to(() => MyAzkarPage());
            },
          )
              : const SizedBox()),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text('logout'.tr, style: const TextStyle(color: Colors.red)),
            onTap: () {
              authController.logout();
              Get.offAll(() => LoginScreen());
            },
          ),
        ],
      ),
    );
  }
}