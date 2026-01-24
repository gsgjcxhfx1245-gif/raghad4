import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';
import 'utils/translations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // الانتقال التلقائي بعد 3 ثواني
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.brown,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: const Icon(
                Icons.mosque,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'app_name'.tr,
              style: TextStyle(
                color: Colors.brown[800],
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'splash_title'.tr,
              style: TextStyle(
                color: Colors.brown[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }}