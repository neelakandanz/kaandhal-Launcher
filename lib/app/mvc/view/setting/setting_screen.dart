import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/background_image/background_image_controller.dart';
import '../../controller/call_button_controller/call_button_controller.dart';
import '../../controller/font_color_controller/font_color_controller.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final FontColorController fontColorController =
      Get.put(FontColorController());
          final CallButtonController callButtonController = Get.put(CallButtonController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Open System Settings'),
            onTap: _openSystemSettings,
          ),
          ListTile(
            leading: const Icon(Icons.format_paint),
            title: const Text('Set Background Theme'),
            onTap: () => showThemeSelectionDialog(context),
          ),
          Obx(() => ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Change Font Color'),
                trailing: Switch(
                  value: fontColorController.isWhite.value,
                  onChanged: (value) {
                    fontColorController.toggleFontColor();
                  },
                ),
              )
              ),
                        Obx(() => ListTile(
                leading: const Icon(Icons.call),
                title: const Text('Enable Call Option'),
                trailing: Switch(
                  value: callButtonController.isCallButtonEnabled.value,
                  onChanged: (value) {
                    callButtonController.toggleCallButton();
                  },
                ),
              )),
        ],
      ),
    );
  }

  void _openSystemSettings() async {
    const platform = MethodChannel('com.example.myapp/openApp');
    try {
      await platform
          .invokeMethod('openApp', {'packageName': 'com.android.settings'});
      log('Opened system settings');
    } on PlatformException catch (e) {
      log('Error opening system settings: ${e.message}');
    }
  }

  void showThemeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ThemeSelectionCarousel(
            onThemeSelected: (selectedImagePath) {
              Get.find<BackgroundImageController>()
                  .setBackgroundImage(selectedImagePath);
              Navigator.pop(context); // Close the dialog
            },
          ),
        );
      },
    );
  }
}

class ThemeSelectionCarousel extends StatefulWidget {
  final ValueChanged<String> onThemeSelected;

  const ThemeSelectionCarousel({super.key, required this.onThemeSelected});

  @override
  ThemeSelectionCarouselState createState() => ThemeSelectionCarouselState();
}

class ThemeSelectionCarouselState extends State<ThemeSelectionCarousel> {
  final PageController _pageController = PageController();
  final List<String> themePaths = [
    'assets/theme/theme1.jpg',
    'assets/theme/theme2.jpg',
    'assets/theme/theme3.jpg',
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: PageView.builder(
            controller: _pageController,
            itemCount: themePaths.length,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                themePaths[index],
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            widget.onThemeSelected(themePaths[_selectedIndex]);
          },
          child: const Text('Set Background Theme'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
