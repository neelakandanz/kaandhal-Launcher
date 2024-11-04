import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Controller class for managing state
class DateTimeController extends GetxController {
  var currentTime = ''.obs;
  var currentDate = ''.obs;
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _startClock();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateFormat('hh:mm:ss a').format(DateTime.now());
      currentDate.value = DateFormat('EEE, MMM d yyyy').format(DateTime.now());
    });
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
