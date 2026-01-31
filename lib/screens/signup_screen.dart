import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AppController appController = Get.find();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('signup'.tr),
        backgroundColor: Colors.brown,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.brown[100],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.brown, width: 3),
                ),
                child: Icon(
                  Icons.person_add,
                  size: 60,
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'create_account'.tr,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
              SizedBox(height: 5),
              Text(
                'انضم إلى مجتمع حصن المسلم',
                style: TextStyle(
                  color: Colors.brown[600],
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'name'.tr,
                  prefixIcon: Icon(Icons.person, color: Colors.brown),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'email'.tr,
                  prefixIcon: Icon(Icons.email, color: Colors.brown),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
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
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'confirm_password'.tr,
                  prefixIcon: Icon(Icons.lock_outline, color: Colors.brown),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.brown,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'signup'.tr,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'have_account'.tr,
                    style: TextStyle(color: Colors.brown[700]),
                  ),
                  SizedBox(width: 5),
                  TextButton(
                    onPressed: () {
                      Get.off(() => LoginScreen());
                    },
                    child: Text(
                      'login'.tr,
                      style: TextStyle(
                        color: Colors.brown[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'يرجى ملء جميع الحقول'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'error'.tr,
        'كلمة المرور يجب أن تكون 6 أحرف على الأقل'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'error'.tr,
        'كلمات المرور غير متطابقة'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'error'.tr,
        'بريد إلكتروني غير صالح'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await appController.signup(name, email, password);

    setState(() => _isLoading = false);

    if (success) {
      Get.offAll(() => HomeScreen());
      Get.snackbar(
        'success'.tr,
        'signup_success'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'error'.tr,
        'فشل إنشاء الحساب'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}