import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FontColorController extends GetxController {
  var isWhite = false.obs; // Default to black

  Color get fontColor => isWhite.value ? Colors.white : Colors.black;

  void toggleFontColor() {
    isWhite.value = !isWhite.value;
  }
}
