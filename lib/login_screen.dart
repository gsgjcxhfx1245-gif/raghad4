import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_page.dart';
import 'controllers/auth_controller.dart';
import 'controllers/language_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(AuthController());
  final LanguageController languageController = Get.put(LanguageController());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(_isLogin ? 'login'.tr : 'create_account'.tr), // ← عدل هنا
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              languageController.toggleLanguage();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
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
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _isLogin ? 'welcome_back'.tr : 'create_account'.tr, // ← عدل هنا
                style: TextStyle(
                  color: Colors.brown[800],
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _isLogin ? 'login_to_continue'.tr : 'join_us'.tr, // ← عدل هنا
                style: TextStyle(
                  color: Colors.brown[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              if (!_isLogin) ...[
                _buildTextField(
                  controller: _nameController,
                  hint: 'full_name'.tr, // ← عدل هنا
                  icon: Icons.person,
                ),
                const SizedBox(height: 20),
              ],
              _buildTextField(
                controller: _emailController,
                hint: 'email'.tr, // ← عدل هنا
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _passwordController,
                hint: 'password'.tr, // ← عدل هنا
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => _isLogin ? _login() : _signup(),
                  child: Text(
                    _isLogin ? 'login'.tr : 'create_account'.tr, // ← عدل هنا
                    style: const TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _clearFields();
                    });
                  },
                  child: Text(
                    _isLogin
                        ? 'no_account'.tr // ← عدل هنا
                        : 'have_account'.tr, // ← عدل هنا
                    style: TextStyle(
                      color: Colors.brown[700],
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.brown[800]),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.brown[400]),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.brown),
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  void _login() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('error'.tr, 'fill_all_fields'.tr); // ← عدل هنا
      return;
    }

    if (authController.login(email, password)) {
      Get.offAll(() => HomePage());
      Get.snackbar('success'.tr, 'login_success'.tr); // ← عدل هنا
    } else {
      Get.snackbar('error'.tr, 'wrong_credentials'.tr); // ← عدل هنا
    }
  }

  void _signup() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('error'.tr, 'fill_all_fields'.tr); // ← عدل هنا
      return;
    }

    if (password.length < 6) {
      Get.snackbar('error'.tr, 'password_min_length'.tr); // ← عدل هنا
      return;
    }

    if (authController.signup(name, email, password)) {
      Get.offAll(() => HomePage());
      Get.snackbar('success'.tr, 'signup_success'.tr); // ← عدل هنا
    } else {
      Get.snackbar('error'.tr, 'email_exists'.tr); // ← عدل هنا
    }
  }

  void _clearFields() {
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
  }
}