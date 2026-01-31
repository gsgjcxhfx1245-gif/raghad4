import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/app_controller.dart';

class AddZekrScreen extends StatefulWidget {
  @override
  _AddZekrScreenState createState() => _AddZekrScreenState();
}

class _AddZekrScreenState extends State<AddZekrScreen> {
  final AppController appController = Get.find();
  final TextEditingController _zekrController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  double _importanceLevel = 3.0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add_zekr'.tr),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveZekr,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Obx(() => appController.selectedImage.value != null
                ? Column(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.brown, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.file(
                      appController.selectedImage.value!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        appController.clearImage();
                      },
                      icon: Icon(Icons.delete),
                      label: Text('حذف الصورة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showImageSourceDialog();
                      },
                      icon: Icon(Icons.edit),
                      label: Text('تغيير الصورة'),
                    ),
                  ],
                ),
              ],
            )
                : GestureDetector(
              onTap: () {
                _showImageSourceDialog();
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFEFEBE9), // لون بني فاتح
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.brown,
                    width: 2,
                  ), // ❌ حذفت dashed
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 60,
                      color: Colors.brown,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'select_image'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF5D4037),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'اضغط لإضافة صورة (اختياري)',
                      style: TextStyle(
                        color: Color(0xFF795548),
                      ),
                    ),
                  ],
                ),
              ),
            )),
            SizedBox(height: 30),
            TextField(
              controller: _zekrController,
              maxLines: 5,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: 'write_zekr_here'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.brown, width: 2),
                ),
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'التصنيف (اختياري)',
                hintText: 'مثال: أذكار الصباح، أذكار النوم، ...',
                prefixIcon: Icon(Icons.category, color: Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Color(0xFFD7CCC8)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'importance_level'.tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4E342E),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: _getImportanceColor(_importanceLevel),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_importanceLevel.round()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 8,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
                      activeTrackColor: _getImportanceColor(_importanceLevel),
                      inactiveTrackColor: Color(0xFFE0E0E0),
                      thumbColor: _getImportanceColor(_importanceLevel),
                    ),
                    child: Slider(
                      value: _importanceLevel,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _importanceLevel.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _importanceLevel = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      bool isActive = (index + 1) <= _importanceLevel;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _importanceLevel = (index + 1).toDouble();
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? _getImportanceColor((index + 1).toDouble())
                                    : Color(0xFFF5F5F5),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isActive
                                      ? _getImportanceColor((index + 1).toDouble())
                                      : Color(0xFFBDBDBD),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isActive ? Colors.white : Color(0xFF616161),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _getImportanceLabel(index + 1),
                              style: TextStyle(
                                fontSize: 12,
                                color: isActive
                                    ? _getImportanceColor((index + 1).toDouble())
                                    : Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveZekr,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 10),
                    Text(
                      'حفظ الذكر',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            if (_zekrController.text.isNotEmpty ||
                appController.selectedImage.value != null)
              TextButton(
                onPressed: () {
                  _zekrController.clear();
                  _categoryController.clear();
                  appController.clearImage();
                  setState(() {
                    _importanceLevel = 3.0;
                  });
                },
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.brown),
              title: Text('من المعرض'),
              onTap: () {
                Get.back();
                appController.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.brown),
              title: Text('التقاط صورة'),
              onTap: () {
                Get.back();
                appController.pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getImportanceColor(double value) {
    if (value <= 2) return Colors.green;
    if (value <= 3) return Colors.orange;
    if (value <= 4) return Colors.orangeAccent;
    return Colors.red;
  }

  String _getImportanceLabel(int value) {
    if (appController.languageController.isArabic.value) {
      switch (value) {
        case 1: return 'منخفض';
        case 2: return 'متوسط';
        case 3: return 'مهم';
        case 4: return 'مهم جداً';
        case 5: return 'أهمية قصوى';
        default: return '';
      }
    } else {
      switch (value) {
        case 1: return 'Low';
        case 2: return 'Medium';
        case 3: return 'High';
        case 4: return 'Very High';
        case 5: return 'Highest';
        default: return '';
      }
    }
  }

  Future<void> _saveZekr() async {
    if (_zekrController.text.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'يرجى كتابة الذكر أولاً'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await appController.addZekr(
        _zekrController.text.trim(),
        _importanceLevel.round(),
        _categoryController.text.trim().isNotEmpty
            ? _categoryController.text.trim()
            : null,
      );

      setState(() => _isLoading = false);

      // مسح الحقول بعد الحفظ
      _zekrController.clear();
      _categoryController.clear();
      appController.clearImage();
      setState(() {
        _importanceLevel = 3.0;
      });

      // إظهار رسالة نجاح
      Get.snackbar(
        'success'.tr,
        'تم إضافة الذكر بنجاح'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      );

      // العودة للشاشة السابقة بعد تأخير بسيط
      await Future.delayed(Duration(milliseconds: 800));
      Get.back();

    } catch (e) {
      setState(() => _isLoading = false);

      Get.snackbar(
        'error'.tr,
        'حدث خطأ أثناء حفظ الذكر: $e'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  void dispose() {
    _zekrController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
}