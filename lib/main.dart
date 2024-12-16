import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/app/modules/login_page/views/login_page_view.dart';
import 'package:myapp/app/modules/register_page/views/register_page_view.dart';
import 'firebase_options.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/modules/connection/controllers/connection_controller.dart';  // Import controller koneksi

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Menginisialisasi ConnectionController
  final connectionController = Get.put(ConnectionController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter App',
      home: Obx(() {
        // Memeriksa apakah terhubung ke internet atau tidak
        final isConnected = Get.find<ConnectionController>().isConnected.value;

        // Menampilkan halaman sesuai status koneksi
        if (isConnected) {
          return HomeView();  // Ganti dengan tampilan home
        } else {
          return NoConnectionScreen();  // Ganti dengan tampilan jika tidak ada koneksi
        }
      }),
      getPages: [
        GetPage(name: '/login', page: () => LoginPageView()),
        GetPage(name: '/register', page: () => RegisterPageView()),
      ],
    );
  }
}

// Halaman jika tidak ada koneksi internet
class NoConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('No Internet')),
      body: Center(
        child: Text(
          'Tidak ada koneksi internet.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
