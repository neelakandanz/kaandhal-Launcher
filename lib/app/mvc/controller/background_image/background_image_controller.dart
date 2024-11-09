import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BackgroundImageController extends GetxController {
  // Store theme path in reactive variable to allow automatic UI updates
  final RxString backgroundImagePath = ''.obs;

  // Storage for persistent theme saving
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Load saved theme path from storage
    backgroundImagePath.value = _storage.read('backgroundImagePath') ?? '';
  }

  // Update theme path in storage and reactive variable
  void setBackgroundImage(String imagePath) {
    backgroundImagePath.value = imagePath;
    _storage.write('backgroundImagePath', imagePath);
  }
}
