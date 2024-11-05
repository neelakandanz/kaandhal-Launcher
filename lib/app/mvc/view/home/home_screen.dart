import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:myapp/app/mvc/controller/date_time/date_time_controller.dart';

import '../../../global/routes/swipeable_page_routes.dart';
import '../setting/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<AppInfo>? apps;
  static const platform = MethodChannel('com.example.myapp/openApp');
  final DateTimeController dateTimeController = Get.put(DateTimeController());

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _fetchInstalledApps();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchInstalledApps() async {
    List<AppInfo> appList = await InstalledApps.getInstalledApps(true, true);
    setState(() {
      apps = appList;
    });
  }

  Future<void> _openApp(String packageName) async {
    try {
      final bool result =
          await platform.invokeMethod('openApp', {'packageName': packageName});
      if (result) {
        log('App opened successfully.');
      } else {
        log('Failed to open app.');
      }
    } on PlatformException catch (e) {
      log('Error: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Obx(() => Text(
                      dateTimeController.currentTime.value,
                      style: const TextStyle(
                          fontSize: 48, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 8),
                Obx(() => Text(
                      dateTimeController.currentDate.value,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w400),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: apps == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: apps!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: apps![index].icon != null
                            ? Image.memory(apps![index].icon!)
                            : null,
                        title: Text(apps![index].name),
                        onTap: () => _openApp(apps![index].packageName),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateWithSwipe(context, const SettingsScreen()),

        //Get.to(() => const SettingsScreen()),
        backgroundColor: const Color.fromARGB(255, 242, 246, 252),
        elevation: 6.0, // Navigate to the settings screen
        child: const Icon(Icons.settings),
      ),
    );
  }
}
