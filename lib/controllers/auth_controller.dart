import 'package:get/get.dart';

class User {
  String name;
  String email;
  String password;
  String profileImage;
  List<String> myPrivateAzkar;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.profileImage,
    List<String>? myPrivateAzkar,
  }) : myPrivateAzkar = myPrivateAzkar ?? [];
}

class AuthController extends GetxController {
  Rx<User?> currentUser = Rx<User?>(null);
  RxList<User> users = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    // مستخدمين افتراضيين
    users.addAll([
      User(
        name: "محمد حمود",
        email: "mohmad@example.com",
        password: "1234",
        profileImage: "👨‍💼",
        myPrivateAzkar: ["اللهم بارك لي في يومي", "سبحان الله وبحمده"],
      ),
      User(
        name: "رغدمنبه",
        email: "RaghadK@example.com",
        password: "654321",
        profileImage: "👩‍💻",
        myPrivateAzkar: ["الحمد لله على نعمة الإسلام", "استغفر الله العظيم"],
      ),
    ]);
  }

  bool login(String email, String password) {
    try {
      User user = users.firstWhere(
            (u) => u.email == email && u.password == password,
      );
      currentUser.value = user;
      return true;
    } catch (e) {
      return false;
    }
  }

  bool signup(String name, String email, String password) {
    if (users.any((u) => u.email == email)) {
      return false;
    }

    User newUser = User(
      name: name,
      email: email,
      password: password,
      profileImage: "👤",
    );

    users.add(newUser);
    currentUser.value = newUser;
    return true;
  }

  void logout() {
    currentUser.value = null;
  }}