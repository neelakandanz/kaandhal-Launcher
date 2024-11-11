import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

import '../../controller/background_image/background_image_controller.dart';
import '../../controller/font_color_controller/font_color_controller.dart';

class AllApps extends StatefulWidget {
  const AllApps({super.key});

  @override
  State<AllApps> createState() => _AllAppsState();
}

class _AllAppsState extends State<AllApps> {
  List<AppInfo> apps = [];
  static const platform = MethodChannel('com.example.myapp/openApp');
  final FontColorController fontColorController =
      Get.put(FontColorController());
  final BackgroundImageController backgroundImageController =
      Get.put(BackgroundImageController());

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            child: apps.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Adjust to change number of columns
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: apps.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _openApp(apps[index].packageName),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            apps[index].icon != null
                                ? Image.memory(
                                    apps[index].icon!,
                                    width: 50, // Adjust the icon size
                                    height: 50,
                                  )
                                : const Icon(Icons.android, size: 50), // Default icon
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
