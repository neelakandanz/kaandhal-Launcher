import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myapp/app/mvc/view/all_apps/all_apps.dart';
import '../../../global/routes/swipeable_page_routes.dart';
import '../../../utils/custom_widgets/custom_text_widget.dart';
import '../../controller/call_button_controller/call_button_controller.dart';
import '../../controller/date_time/date_time_controller.dart';
import '../../controller/background_image/background_image_controller.dart';
import '../../controller/font_color_controller/font_color_controller.dart';
import '../setting/setting_screen.dart';
import 'dart:ui'; // Required for BackdropFilter

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
  }

  void _openCallApp() async {
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
      body: GestureDetector(
        onHorizontalDragStart: (details) {
          navigateWithSwipe(context, const AllApps());
        },
        child: Obx(
          () => Stack(
            children: [
              // Background
             Container(
            decoration: backgroundImageController.backgroundImagePath.isNotEmpty
                ? BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          backgroundImageController.backgroundImagePath.value),
                      fit: BoxFit.cover,
                    ),
                  )
                : null,
                  // gradient: backgroundImageController
                  //         .backgroundImagePath.isEmpty
                  //     ? const LinearGradient(
                  //         colors: [Colors.blueAccent, Colors.deepPurpleAccent],
                  //         begin: Alignment.topCenter,
                  //         end: Alignment.bottomCenter,
                  //       )
                   //   : null,
                
              ),
              // Glassmorphism effect
              // Center(
              //   child: BackdropFilter(
              //     filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              //     child: Container(
              //       alignment: Alignment.center,
              //       color: Colors.black.withOpacity(0.2), // Frosted effect
              //     ),
              //   ),
              // ),
              // Main Content: Date & Time
              Positioned(
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10,),
                    // Date at the top
                    Obx(
                      () => TextTimeWidget(
                        text: dateTimeController.currentDate.value,
                        color: fontColorController.fontColor,
                        fontSize: 24.0,
                      ),
                    ),
                    // Time at the bottom center
                    Obx(
                      () => TextTimeWidget(
                        text: dateTimeController.currentTime.value,
                        color: fontColorController.fontColor,
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Rounded icons at the bottom
              Positioned(
                bottom: 40,
                left: 40,
                child: _buildGlassIcon(
                  icon: Icons.call,
                  onTap: _openCallApp,
                ),
              ),
              Positioned(
                bottom: 40,
                right: 40,
                child: _buildGlassIcon(
                  icon: Icons.settings,
                  onTap: () => navigateWithSwipe(context, SettingsScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Glass-like button builder for icons
  Widget _buildGlassIcon(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}
