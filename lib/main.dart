import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/app/modules/login_page/views/login_page_view.dart';
import 'package:myapp/app/modules/register_page/views/register_page_view.dart';
import 'firebase_options.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => RegisterPageView()),
        GetPage(name: '/login', page: () => LoginPageView()),
        GetPage(name: '/home', page: () => HomeView()), // Tambahkan HomeView
      ],
    );
  }
}