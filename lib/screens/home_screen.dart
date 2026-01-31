import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import 'add_zekr_screen.dart';
import 'my_azkar_screen.dart';
import 'statistic_screen.dart';
import 'language_settings.dart';

// Model للصلاة
class PrayerTime {
  final String name;
  final String time;
  final IconData icon;

  PrayerTime({
    required this.name,
    required this.time,
    required this.icon,
  });
}

class HomeScreen extends StatelessWidget {
  final AppController appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('app_name'.tr),
        centerTitle: true,
        actions: [
          // زر تغيير اللغة السريع
          IconButton(
            icon: Obx(() => Text(
              appController.languageController.isArabic.value ? 'EN' : 'ع',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
            onPressed: () {
              appController.toggleLanguage();
            },
          ),
          // إعدادات اللغة
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              Get.to(() => LanguageSettingsScreen());
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddZekrScreen());
        },
        backgroundColor: Colors.brown,
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'my_azkar'.tr,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'statistics'.tr,
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Get.to(() => MyAzkarScreen());
          } else if (index == 2) {
            Get.to(() => StatisticsScreen());
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقة ترحيب
          Obx(() => appController.currentUser.value != null
              ? Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.brown[100],
                    child: Text(
                      appController.currentUser.value!.profileImage,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${'welcome'.tr} ${appController.currentUser.value!.name}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          appController.currentUser.value!.email,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
              : SizedBox()),

          SizedBox(height: 25),

          // أذكار الصباح
          _buildSectionTitle('morning_azkar'.tr, Icons.wb_sunny),
          SizedBox(height: 10),
          Obx(() => appController.morningAzkar.isEmpty
              ? _buildLoading()
              : Column(
            children: appController.morningAzkar
                .take(2)
                .map((azkar) => _buildAzkarCard(
              azkar['content_ar']?.toString() ?? '',
              azkar['description']?.toString() ?? '',
              Icons.wb_sunny,
              Colors.orange[100]!,
            ))
                .toList(),
          )),

          SizedBox(height: 25),

          // أذكار المساء
          _buildSectionTitle('evening_azkar'.tr, Icons.nightlight_round),
          SizedBox(height: 10),
          Obx(() => appController.eveningAzkar.isEmpty
              ? _buildLoading()
              : Column(
            children: appController.eveningAzkar
                .take(2)
                .map((azkar) => _buildAzkarCard(
              azkar['content_ar']?.toString() ?? '',
              azkar['description']?.toString() ?? '',
              Icons.nightlight_round,
              Colors.blue[100]!,
            ))
                .toList(),
          )),

          SizedBox(height: 25),

          // تذكيرات الصلاة
          _buildSectionTitle('prayer_reminders'.tr, Icons.access_time),
          SizedBox(height: 10),
          _buildPrayerTimes(),

          SizedBox(height: 25),

          // الإحصائيات السريعة
          Obx(() => appController.currentUser.value != null
              ? _buildQuickStats()
              : SizedBox()),

          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.brown,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.brown[800]!, Colors.brown[400]!],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    Icons.mosque,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'app_name'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => appController.currentUser.value != null
              ? UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.brown[100]),
            accountName: Text(appController.currentUser.value!.name),
            accountEmail: Text(appController.currentUser.value!.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.brown[200],
              child: Text(
                appController.currentUser.value!.profileImage,
                style: TextStyle(fontSize: 24),
              ),
            ),
          )
              : SizedBox()),
          ListTile(
            leading: Icon(Icons.home, color: Colors.brown),
            title: Text('الرئيسية'),
            onTap: () {
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.add, color: Colors.brown),
            title: Text('add_zekr'.tr),
            onTap: () {
              Get.back();
              Get.to(() => AddZekrScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.list, color: Colors.brown),
            title: Text('my_azkar'.tr),
            onTap: () {
              Get.back();
              Get.to(() => MyAzkarScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart, color: Colors.brown),
            title: Text('statistics'.tr),
            onTap: () {
              Get.back();
              Get.to(() => StatisticsScreen());
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language, color: Colors.brown),
            title: Text('change_language'.tr),
            onTap: () {
              Get.back();
              Get.to(() => LanguageSettingsScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.brown),
            title: Text('settings'.tr),
            onTap: () {
              // يمكنك إضافة شاشة الإعدادات هنا
            },
          ),
          Divider(),
          Obx(() => appController.currentUser.value != null
              ? ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              'logout'.tr,
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Get.back();
              appController.logout();
              Get.snackbar(
                'success'.tr,
                'logout_success'.tr,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
          )
              : SizedBox()),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.brown),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.brown[800],
          ),
        ),
      ],
    );
  }

  Widget _buildAzkarCard(String zekr, String description, IconData icon, Color color) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.brown),
        ),
        title: Text(
          zekr,
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 16),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          description,
          textAlign: TextAlign.right,
          style: TextStyle(color: Colors.grey),
        ),
        trailing: IconButton(
          icon: Icon(Icons.volume_up, color: Colors.brown),
          onPressed: () {
            Get.snackbar(
              'بدأ الذكر',
              'جاري تلاوة الذكر...',
              backgroundColor: Colors.brown,
              colorText: Colors.white,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPrayerTimes() {
    final List<PrayerTime> prayerTimes = [
      PrayerTime(name: 'الفجر', time: '5:30', icon: Icons.nightlight_round),
      PrayerTime(name: 'الظهر', time: '12:15', icon: Icons.wb_sunny),
      PrayerTime(name: 'العصر', time: '3:45', icon: Icons.wb_cloudy),
      PrayerTime(name: 'المغرب', time: '6:20', icon: Icons.sunny),
      PrayerTime(name: 'العشاء', time: '7:45', icon: Icons.nights_stay),
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: prayerTimes.map((prayer) {
            return ListTile(
              leading: Icon(prayer.icon, color: Colors.brown),
              title: Text(prayer.name),
              trailing: Text(
                prayer.time,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
              onTap: () {
                Get.snackbar(
                  'تذكير ${prayer.name}',
                  'حان وقت صلاة ${prayer.name}',
                  backgroundColor: Colors.brown,
                  colorText: Colors.white,
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إحصائيات سريعة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  value: appController.totalAzkar.value.toString(),
                  label: 'total_azkar'.tr,
                  icon: Icons.format_list_numbered,
                  color: Colors.blue,
                ),
                _buildStatItem(
                  value: appController.todayCount.value.toString(),
                  label: 'completed_today'.tr,
                  icon: Icons.today,
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, size: 30, color: color),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(color: Colors.brown),
      ),
    );
  }
}