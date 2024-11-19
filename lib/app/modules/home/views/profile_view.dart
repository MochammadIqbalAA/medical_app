import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/app/modules/login_page/views/login_page_view.dart'; // Pastikan untuk mengimpor halaman login

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Be Vietnam Pro',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: const Color(0xFFA9D6EB),
      ),
      body: Container(
        color: const Color(0xFFA9D6EB),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  // CircleAvatar
                  CircleAvatar(
                    radius: 120,
                    backgroundImage: AssetImage('assets/default_profile.png'), // Ganti dengan logika gambar profil
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Logika untuk memilih gambar dari galeri (tambahkan jika perlu)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF151855),
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Pick Image from Gallery',
                  style: TextStyle(fontFamily: 'Be Vietnam pro', fontSize: 20),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Logika untuk mereset gambar profil (tambahkan jika perlu)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF151855),
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Reset Profile Image',
                  style: TextStyle(fontFamily: 'Be Vietnam pro', fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut(); // Melakukan logout
                  // Navigasi ke halaman login setelah logout
                  Get.offAll(LoginPageView()); // Langsung arahkan ke LoginPageView
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF151855),
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(fontFamily: 'Be Vietnam pro', fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}