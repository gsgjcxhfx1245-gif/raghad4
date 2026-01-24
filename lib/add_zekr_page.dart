import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/zekr_controller.dart';
import 'controllers/language_controller.dart';

class AddZekrPage extends StatefulWidget {
  const AddZekrPage({super.key});

  @override
  State<AddZekrPage> createState() => _AddZekrPageState();
}

class _AddZekrPageState extends State<AddZekrPage> {
  final TextEditingController _controller = TextEditingController();
  final AuthController authController = Get.find();
  final ZekrController zekrController = Get.put(ZekrController());
  final LanguageController languageController = Get.find();

  @override
  void initState() {
    super.initState();
    zekrController.importanceLevel.value = 3.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('add_zekr'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              languageController.toggleLanguage();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Obx(() => zekrController.selectedImage.value != null
              ? Column(
            children: [
              Image.file(
                zekrController.selectedImage.value!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => zekrController.clearImage(),
                child: Text('delete_image'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          )
              : ElevatedButton(
            onPressed: () => zekrController.pickImage(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.photo),
                const SizedBox(width: 8),
                Text('choose_image'.tr),
              ],
            ),
          )),

          const SizedBox(height: 20),

          TextField(
            controller: _controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'write_zekr_here'.tr,
              border: const OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.brown),
            ),
            child: Column(
              children: [
                Text(
                  '🔥 ${'importance_level'.tr} 🔥',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),

                const SizedBox(height: 20),

                Obx(() => Slider(
                  value: zekrController.importanceLevel.value,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: zekrController.importanceLevel.value.round().toString(),
                  activeColor: _getSliderColor(zekrController.importanceLevel.value),
                  inactiveColor: Colors.grey[300],
                  thumbColor: Colors.blue,
                  onChanged: (value) {
                    zekrController.setImportance(value);
                  },
                )),

                const SizedBox(height: 10),

                Obx(() => Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.brown),
                  ),
                  child: Text(
                    '${'importance_level'.tr}: ${zekrController.importanceLevel.value.round()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                )),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    return Obx(() => Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: (index + 1) <= zekrController.importanceLevel.value.round()
                            ? _getSliderColor(index + 1)
                            : Colors.grey[200],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.brown),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: (index + 1) <= zekrController.importanceLevel.value.round()
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ));
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                if (authController.currentUser.value != null) {
                  authController.currentUser.value!.myPrivateAzkar.add(_controller.text);
                  _controller.clear();
                  zekrController.clearImage();
                  zekrController.setImportance(3.0);

                  Get.snackbar(
                    'done'.tr,
                    'zekr_added'.tr,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    'error'.tr,
                    'must_login'.tr,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text('add_zekr_button'.tr),
          ),
        ],
      ),
    );
  }

  Color _getSliderColor(double value) {
    if (value <= 2) return Colors.green;
    if (value <= 3) return Colors.orange;
    if (value <= 4) return Colors.orangeAccent;
    return Colors.red;
  }
}