import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AppController appController = Get.find();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 40),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.brown[800]!, Colors.brown[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.mosque,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'app_name'.tr,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                  fontFamily: 'Tajawal',
                ),
              ),
              SizedBox(height: 10),
              Text(
                'حصن المسلم - تطوير النفس والروح',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.brown[600],
                ),
              ),
              SizedBox(height: 50),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'email'.tr,
                  prefixIcon: Icon(Icons.email, color: Colors.brown),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.brown, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'password'.tr,
                  prefixIcon: Icon(Icons.lock, color: Colors.brown),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.brown,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.brown, width: 2),
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    shadowColor: Colors.brown.withOpacity(0.3),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'login'.tr,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'no_account'.tr,
                    style: TextStyle(color: Colors.brown[700]),
                  ),
                  SizedBox(width: 5),
                  TextButton(
                    onPressed: () {
                      Get.to(() => SignupScreen());
                    },
                    child: Text(
                      'signup'.tr,
                      style: TextStyle(
                        color: Colors.brown[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Obx(() => ElevatedButton.icon(
                onPressed: () {
                  appController.toggleLanguage();
                },
                icon: Icon(Icons.language),
                label: Text(appController.languageController.isArabic.value ? 'English' : 'العربية'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.brown),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'يرجى ملء جميع الحقول'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await appController.login(email, password);

    setState(() => _isLoading = false);

    if (success) {
      Get.offAll(() => HomeScreen()); // ✅ هنا ينتقل إلى Home Page
      Get.snackbar(
        'success'.tr,
        'login_success'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.snackbar(
        'error'.tr,
        'البريد الإلكتروني أو كلمة المرور غير صحيحة'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}