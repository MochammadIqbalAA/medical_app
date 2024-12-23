import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/home/controllers/profile_controller.dart'; // Ensure you import the ProfileController
import 'package:myapp/app/modules/home/views/profile_view.dart';
import 'package:myapp/app/modules/login_page/views/login_page_view.dart';
import 'package:myapp/app/modules/LabTestResult/views/lab_test_result_view.dart'; // Import LabTestResultPage
import 'package:myapp/app/modules/faq/views/faq_view.dart'; // Import FAQPage

class ProfileMenuView extends StatelessWidget {
  ProfileMenuView({Key? key}) : super(key: key);

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          final email = user.email!;

          return _buildProfileMenu(context, email);
        } else {
          return Scaffold(
            appBar: AppBar(title: const Text('Belum Login')),
            body: const Center(child: Text('Anda belum login')),
          );
        }
      },
    );
  }

  Future<User?> _getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Widget _buildProfileMenu(BuildContext context, String email) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.lightBlue[100],
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
          secondary: Colors.blueAccent,
        ),
        fontFamily: 'Roboto',
        textTheme: Theme.of(context).textTheme.copyWith(
              displayMedium:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              bodyMedium: const TextStyle(fontSize: 16),
            ),
      ),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 141, 205, 235),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Obx(() {
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            controller.selectedImagePath.isNotEmpty
                                ? FileImage(File(controller.selectedImagePath.value))
                                : const AssetImage('assets/profile_picture.jpg'),
                      );
                    }),
                    const SizedBox(height: 10),
                    Text(
                      email,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500), // Custom font style
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.all(16.0),
                  shape:
                      RoundedRectangleBorder(borderRadius:
                          BorderRadius.circular(10.0)),
                  child:
                      ListView(padding:
                          const EdgeInsets.symmetric(vertical:
                              16.0), children:[
                        ProfileMenuItem(icon:
                            Icons.person,text:'Profile Edit',onTap:
                            () {Navigator.push(context,MaterialPageRoute(builder:(context)=>ProfileView()));},),
                        ProfileMenuItem(icon :Icons.science,text:'Lab Test Result',onTap :(){Navigator.push(context ,MaterialPageRoute(builder :(context)=>LabTestResultView()));},),
                        ProfileMenuItem(icon :Icons.question_answer,text:'FAQ',onTap :(){Navigator.push(context ,MaterialPageRoute(builder :(context)=>FAQView()));},),
                        ProfileMenuItem(icon :Icons.logout,text:'Logout',textColor :Colors.red,onTap :(){FirebaseAuth.instance.signOut().then((_) {Navigator.pushReplacement(context ,MaterialPageRoute(builder :(context)=>LoginPageView()),);});},),],),),),],),),),);
}
}

class ProfileMenuItem extends StatelessWidget {final IconData icon;final String text;final Color? textColor;final VoidCallback? onTap;const ProfileMenuItem({Key? key,required this.icon ,required this.text,this.textColor ,this.onTap ,}):super(key:key);@override Widget build(BuildContext context){return ListTile(leading :Icon(icon,color :Theme.of(context).colorScheme.secondary),title :Text(text ,style :TextStyle(color:textColor ??Theme.of(context).textTheme.bodyMedium!.color)),onTap:onTap ??() {},);}}
