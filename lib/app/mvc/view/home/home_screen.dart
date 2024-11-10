import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

import '../../../global/routes/swipeable_page_routes.dart';
import '../../../utils/custom_widgets/custom_text_widget.dart';
import '../../controller/call_button_controller/call_button_controller.dart';
import '../../controller/date_time/date_time_controller.dart';
import '../../controller/background_image/background_image_controller.dart';
import '../../controller/font_color_controller/font_color_controller.dart';
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
  final CallButtonController callButtonController = Get.find();

  final BackgroundImageController backgroundImageController =
      Get.put(BackgroundImageController());
  final FontColorController fontColorController =
      Get.put(FontColorController());
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _fetchInstalledApps();
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
      log(result ? 'App opened successfully.' : 'Failed to open app.');
    } on PlatformException catch (e) {
      log('Error: ${e.message}');
    }
  }

  void _openCallApp() async {
    const platform = MethodChannel('com.example.myapp/openApp');
    try {
      await platform.invokeMethod(
          'openApp', {'packageName': 'com.google.android.dialer'});
      log('Opened Google Dialer app');
    } on PlatformException catch (e) {
      log('Error opening Google Dialer app: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Container(
          decoration: backgroundImageController.backgroundImagePath.isNotEmpty
              ? BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        backgroundImageController.backgroundImagePath.value),
                    fit: BoxFit.cover,
                  ),
                )
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Obx(
                    () => TextTimeWidget(
                      text: dateTimeController.currentTime.value,
                      color: fontColorController.fontColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => TextTimeWidget(
                      text: dateTimeController.currentDate.value,
                      color: fontColorController.fontColor,
                      fontSize: 24.0,
                    ),
                  ),
                ],
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
                            title: TextTimeWidget(
                              text: (apps![index].name),
                              color: fontColorController.fontColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,

                            ),
                            onTap: () => _openApp(apps![index].packageName),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          // Settings Floating Action Button
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => navigateWithSwipe(context, SettingsScreen()),
              backgroundColor: Colors.white,
              elevation: 6.0,
              child: const Icon(Icons.settings),
            ),
          ),
          // Call Floating Action Button (conditionally visible)
          Obx(() => callButtonController.isCallButtonEnabled.value
              ? Positioned(
                  bottom: 16,
                  right: 80, // Adjust positioning to avoid overlap
                  child: FloatingActionButton(
                    onPressed: _openCallApp,
                    backgroundColor: Colors.white,
                    elevation: 6.0,
                    child: const Icon(Icons.call),
                  ),
                )
              : Container()),
        ],
      ),
    );
  }
}
