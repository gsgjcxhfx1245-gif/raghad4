import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ZekrController extends GetxController {
  // لاختيار الصورة
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxDouble importanceLevel = 3.0.obs;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  void clearImage() {
    selectedImage.value = null;
  }

  void setImportance(double value) {
    importanceLevel.value = value;
  }}