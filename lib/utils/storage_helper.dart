import 'package:get_storage/get_storage.dart';

class StorageHelper {
  static final GetStorage _box = GetStorage();

  static Future<void> saveLanguage(String languageCode) async {
    await _box.write('app_language', languageCode);
  }

  static String getLanguage() {
    return _box.read('app_language') ?? 'ar';
  }

  static bool isArabic() {
    return getLanguage() == 'ar';
  }

  static Future<void> saveUserData(Map<String, dynamic> data) async {
    await _box.write('user_data', data);
  }

  static Map<String, dynamic>? getUserData() {
    return _box.read('user_data');
  }

  static Future<void> clearAll() async {
    await _box.erase();
  }

  static Future<void> saveValue(String key, dynamic value) async {
    await _box.write(key, value);
  }

  static dynamic getValue(String key, {dynamic defaultValue}) {
    return _box.read(key) ?? defaultValue;
  }

  static Future<void> removeValue(String key) async {
    await _box.remove(key);
  }
}