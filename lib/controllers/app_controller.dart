import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../database/database_helper.dart';
import '../models/user_model.dart';
import '../models/zekr_model.dart';
import 'language_controller.dart';

class AppController extends GetxController {
  final LanguageController languageController = Get.find();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ImagePicker _picker = ImagePicker();

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxList<Zekr> azkarList = <Zekr>[].obs;
  final RxList<Map<String, dynamic>> morningAzkar = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> eveningAzkar = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> prayerAzkar = <Map<String, dynamic>>[].obs;

  final RxInt totalAzkar = 0.obs;
  final RxInt todayCount = 0.obs;
  final RxInt weeklyCount = 0.obs;
  final RxInt monthlyCount = 0.obs;

  final Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    _checkLoggedInUser();
  }

  Future<void> _loadInitialData() async {
    await _loadGeneralAzkar();
  }

  Future<void> _checkLoggedInUser() async {
    final box = GetStorage();
    final lastUser = box.read('last_user_email');
    if (lastUser != null) {
      final user = await _dbHelper.getUserByEmail(lastUser);
      if (user != null) {
        currentUser.value = user;
        await _loadUserAzkar();
        await _loadStatistics();
      }
    }
  }

  Future<void> _loadGeneralAzkar() async {
    final morning = await _dbHelper.getMorningAzkar();
    final evening = await _dbHelper.getEveningAzkar();
    final prayer = await _dbHelper.getPrayerAzkar();

    morningAzkar.assignAll(morning);
    eveningAzkar.assignAll(evening);
    prayerAzkar.assignAll(prayer);
  }

  Future<void> _loadUserAzkar() async {
    if (currentUser.value == null) return;

    final azkar = await _dbHelper.getAzkarByUser(currentUser.value!.id);
    azkarList.assignAll(azkar);
  }

  Future<void> _loadStatistics() async {
    if (currentUser.value == null) return;

    try {
      final stats = await _dbHelper.getAzkarStatistics(currentUser.value!.id);

      totalAzkar.value = stats['total'] ?? 0;
      todayCount.value = stats['today'] ?? 0;
      weeklyCount.value = stats['weekly'] ?? 0;
      monthlyCount.value = stats['monthly'] ?? 0;

      print('Statistics loaded: $stats');
    } catch (e) {
      print('Error loading statistics: $e');
      totalAzkar.value = 0;
      todayCount.value = 0;
      weeklyCount.value = 0;
      monthlyCount.value = 0;
    }
  }

  // ========== Authentication ==========
  Future<bool> login(String email, String password) async {
    try {
      final user = await _dbHelper.login(email, password);
      if (user != null) {
        currentUser.value = user;
        GetStorage().write('last_user_email', email);
        await _loadUserAzkar();
        await _loadStatistics();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    try {
      final existingUser = await _dbHelper.getUserByEmail(email);
      if (existingUser != null) {
        Get.snackbar('error'.tr, 'البريد الإلكتروني مستخدم مسبقاً'.tr);
        return false;
      }

      final user = User(
        id: 0,
        name: name,
        email: email,
        password: password,
        profileImage: '👤',
        createdAt: DateTime.now(),
      );

      final userId = await _dbHelper.insertUser(user);
      if (userId > 0) {
        user.id = userId;
        currentUser.value = user;
        GetStorage().write('last_user_email', email);
        return true;
      }
      return false;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  void logout() {
    currentUser.value = null;
    azkarList.clear();
    GetStorage().remove('last_user_email');
    selectedImage.value = null;
    totalAzkar.value = 0;
    todayCount.value = 0;
    weeklyCount.value = 0;
    monthlyCount.value = 0;
  }

  // ========== Zekr Management ==========
  Future<void> addZekr(String content, int importance, String? category) async {
    if (currentUser.value == null) {
      Get.snackbar(
        'error'.tr,
        'يجب تسجيل الدخول أولاً'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final zekr = Zekr(
        id: 0,
        content: content,
        importance: importance,
        imagePath: selectedImage.value?.path,
        category: category,
        createdAt: DateTime.now(),
        userId: currentUser.value!.id,
      );

      final newId = await _dbHelper.insertZekr(zekr);

      // تحديث الـ ID بعد الإدخال
      zekr.id = newId;

      // إضافته للقائمة
      azkarList.insert(0, zekr);

      // تحديث الإحصائيات
      await _updateStatistics();

      // مسح الصورة المختارة
      selectedImage.value = null;

      Get.snackbar(
        'success'.tr,
        'تم إضافة الذكر بنجاح'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

    } catch (e) {
      print('Error in addZekr: $e');
      Get.snackbar(
        'error'.tr,
        'فشل إضافة الذكر'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> deleteZekr(int index) async {
    if (index >= azkarList.length) return;

    final zekr = azkarList[index];
    try {
      await _dbHelper.deleteZekr(zekr.id);
      azkarList.removeAt(index);
      await _updateStatistics();
      Get.snackbar('success'.tr, 'تم حذف الذكر'.tr);
    } catch (e) {
      print('Delete zekr error: $e');
      Get.snackbar('error'.tr, 'فشل حذف الذكر'.tr);
    }
  }

  Future<void> _updateStatistics() async {
    await _loadStatistics();
  }

  // ========== Image Picker ==========
  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      print('Image picker error: $e');
      Get.snackbar('error'.tr, 'فشل اختيار الصورة'.tr);
    }
  }

  void clearImage() {
    selectedImage.value = null;
  }

  // ========== Language Management ==========
  void toggleLanguage() {
    languageController.toggleLanguage();
  }

  // Helper methods
  Color getImportanceColor(int importance) {
    switch (importance) {
      case 1: return Colors.green;
      case 2: return Colors.lightGreen;
      case 3: return Colors.orange;
      case 4: return Colors.orangeAccent;
      case 5: return Colors.red;
      default: return Colors.grey;
    }
  }

  String getImportanceText(int importance) {
    if (languageController.isArabic.value) {
      switch (importance) {
        case 1: return 'منخفض';
        case 2: return 'متوسط منخفض';
        case 3: return 'متوسط';
        case 4: return 'مرتفع';
        case 5: return 'مهم جداً';
        default: return 'متوسط';
      }
    } else {
      switch (importance) {
        case 1: return 'Low';
        case 2: return 'Medium Low';
        case 3: return 'Medium';
        case 4: return 'High';
        case 5: return 'Very High';
        default: return 'Medium';
      }
    }
  }
}