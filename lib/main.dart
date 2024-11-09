import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

import 'app/mvc/controller/date_time/date_time_controller.dart';
import 'app/mvc/controller/background_image/background_image_controller.dart';
import 'app/mvc/view/home/home_screen.dart'; // Add this package for date formatting
//add assets floder

void main() async{
   // Initialize GetStorage to persist theme selection
  await GetStorage.init();
  
  // Initialize controllers at the start of the app
  Get.put(BackgroundImageController());
  Get.put(DateTimeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
