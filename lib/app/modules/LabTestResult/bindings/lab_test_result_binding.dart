import 'package:get/get.dart';

import '../controllers/lab_test_result_controller.dart';

class LabTestResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LabTestResultController>(
      () => LabTestResultController(),
    );
  }
}
