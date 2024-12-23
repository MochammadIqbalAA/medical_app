import 'package:get/get.dart';
import '../modules/DoctorDetailPage/bindings/doctor_detail_page_binding.dart';
import '../modules/DoctorDetailPage/views/doctor_detail_page_view.dart';
import '../modules/FindUsPage/bindings/find_us_page_binding.dart';
import '../modules/FindUsPage/views/find_us_page_view.dart';
import '../modules/Forum/bindings/forum_binding.dart';
import '../modules/Forum/views/ForumPage.dart';
import '../modules/appointment/bindings/appointment_binding.dart';
import '../modules/appointment/views/appointment_page.dart';
import '../modules/connection/bindings/connection_binding.dart';
import '../modules/connection/views/connection_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login_page/bindings/login_page_binding.dart';
import '../modules/login_page/views/login_page_view.dart';
import '../modules/register_page/bindings/register_page_binding.dart';
import '../modules/register_page/views/register_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_PAGE,
      page: () => RegisterPageView(),
      binding: RegisterPageBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_PAGE,
      page: () => LoginPageView(),
      binding: LoginPageBinding(),
    ),
    GetPage(
      name: _Paths.APPOINTMENT,
      page: () => AppointmentView(),
      binding: AppointmentBinding(),
    ),
    GetPage(
      name: _Paths.FORUM,
      page: () => ForumPage(),
      binding: ForumBinding(),
    ),
    GetPage(
      name: _Paths.FIND_US_PAGE,
      page: () => const FindUsPage(),
      binding: FindUsPageBinding(),
    ),
    GetPage(
      name: _Paths.CONNECTION,
      page: () => ConnectionView(),
      binding: ConnectionBinding(),
    ),
    GetPage(
      name: _Paths.DOCTOR_DETAIL_PAGE,
      page: () {
      // Mengambil parameter yang diperlukan untuk halaman ini
      final namaDokter = Get.parameters['nama_dokter'] ?? 'Unknown Doctor';

      // Mengirimkan parameter yang diperlukan ke DoctorDetailPageView
      return DoctorDetailPageView(
      nama_dokter: namaDokter,
    );
  },
      binding: DoctorDetailPageBinding(),
)


  ];
}
