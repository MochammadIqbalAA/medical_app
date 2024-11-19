import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/modules/login_page/views/login_page_view.dart'; // Impor HomeView

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  // Fungsi untuk registrasi pengguna
  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar(
        'Success',
        'Registration successful',
        backgroundColor: Colors.green,
      );
      Get.off(LoginPageView()); // Beralih ke halaman Login setelah registrasi
    } catch (error) {
      Get.snackbar(
        'Error',
        'Registration failed: $error',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk login pengguna
  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar(
        'Success',
        'Login successful',
        backgroundColor: Colors.green,
      );
      Get.offAll(HomeView()); // Navigasi ke halaman HomeView setelah login
    } catch (error) {
      Get.snackbar(
        'Error',
        'Login failed: $error',
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk logout pengguna
  void logout() async {
    await _auth.signOut();
    Get.offAll(LoginPageView());
  }
}