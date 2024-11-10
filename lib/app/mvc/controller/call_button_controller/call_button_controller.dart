import 'package:get/get.dart';

class CallButtonController extends GetxController {
  var isCallButtonEnabled = false.obs;

  void toggleCallButton() {
    isCallButtonEnabled.value = !isCallButtonEnabled.value;
  }
}
