import 'package:get/get.dart';

import 'package:myapp/app/modules/FindUsPage/controllers/find_us_page_controller.dart';

class FindUsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FindUsController>(
      () => FindUsController(),
    );
  }
}
