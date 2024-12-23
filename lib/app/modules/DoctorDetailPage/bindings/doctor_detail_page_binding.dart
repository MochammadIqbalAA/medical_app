import 'package:get/get.dart';

import '../controllers/doctor_detail_page_controller.dart';

class DoctorDetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorDetailPageController>(
      () => DoctorDetailPageController(),
    );
  }
}
