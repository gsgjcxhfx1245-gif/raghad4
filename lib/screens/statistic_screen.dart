import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppController appController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('statistics'.tr),
        backgroundColor: Colors.brown,
      ),
      body: Obx(() {
        if (appController.currentUser.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off, size: 80, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  'يجب تسجيل الدخول لعرض الإحصائيات'.tr,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // بطاقة الإحصائيات الرئيسية
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'إحصائيات الأذكار'.tr,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                              'total_azkar'.tr,
                              appController.totalAzkar.value.toString(),
                              Icons.format_list_numbered,
                              Colors.blue
                          ),
                          _buildStatCard(
                              'completed_today'.tr,
                              appController.todayCount.value.toString(),
                              Icons.today,
                              Colors.green
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                              'weekly_progress'.tr,
                              appController.weeklyCount.value.toString(),
                              Icons.calendar_view_week,
                              Colors.orange
                          ),
                          _buildStatCard(
                              'monthly_progress'.tr,
                              appController.monthlyCount.value.toString(),
                              Icons.calendar_today,
                              Colors.purple
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              // توزيع الأهمية
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'توزيع الأهمية'.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800],
                        ),
                      ),
                      SizedBox(height: 15),
                      ...List.generate(5, (index) {
                        final importance = index + 1;
                        final count = appController.azkarList
                            .where((z) => z.importance == importance)
                            .length;
                        final total = appController.azkarList.length;
                        final percentage = total > 0 ? (count / total * 100) : 0;

                        return Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: appController.getImportanceColor(importance),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '$importance',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        appController.getImportanceText(importance),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '$count (${percentage.toStringAsFixed(1)}%)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              LinearProgressIndicator(
                                value: total > 0 ? count / total : 0,
                                backgroundColor: Colors.grey[200],
                                color: appController.getImportanceColor(importance),
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              // آخر الأذكار
              if (appController.azkarList.isNotEmpty) ...[
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'آخر الأذكار المضافة'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[800],
                          ),
                        ),
                        SizedBox(height: 15),
                        ...appController.azkarList.take(5).map((zekr) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: appController.getImportanceColor(zekr.importance),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${zekr.importance}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              zekr.content.length > 50
                                  ? '${zekr.content.substring(0, 50)}...'
                                  : zekr.content,
                              maxLines: 2,
                            ),
                            subtitle: Text(
                              '${zekr.createdAt.day}/${zekr.createdAt.month}/${zekr.createdAt.year}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, size: 30, color: color),
        ),
        SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}