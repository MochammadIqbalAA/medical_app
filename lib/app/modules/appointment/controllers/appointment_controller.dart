import 'dart:io';
import 'package:flutter/material.dart'; // Untuk Colors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppointmentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final box = GetStorage();
  var isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkConnectivity();
    _listenConnectivity();
  }

 
  Future<void> _checkConnectivity() async {
    List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    _validateConnection(results);
  }


  void _listenConnectivity() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _validateConnection(results);
    });
  }


  Future<void> _validateConnection(List<ConnectivityResult> results) async {
    if (results.contains(ConnectivityResult.wifi) || results.contains(ConnectivityResult.mobile)) {
      try {
        final response = await InternetAddress.lookup('google.com');
        isConnected.value = response.isNotEmpty && response[0].rawAddress.isNotEmpty;
      } catch (e) {
        isConnected.value = false;
      }
    } else {
      isConnected.value = false;
    }

    Get.snackbar(
      "Koneksi Internet",
      isConnected.value ? "Terhubung ke internet" : "Tidak ada koneksi internet",
      snackPosition: SnackPosition.TOP,
      backgroundColor: isConnected.value ? Colors.green : Colors.red,
      colorText: Colors.white,
    );

    if (isConnected.value) retryPendingUploads();
  }




  void addAppointment(Map<String, dynamic> data) async {
    if (isConnected.value) {
      try {
        await _firestore.collection('appointments').add(data);
        Get.snackbar("Berhasil", "Janji temu berhasil ditambahkan",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      } catch (e) {
        _saveToLocal(data);
      }
    } else {
      _saveToLocal(data);
      Get.snackbar("Offline", "Data disimpan lokal",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
    }
  }

  // Fungsi memperbarui janji temu
  void updateAppointment(String id, Map<String, dynamic> data) async {
    if (isConnected.value) {
      try {
        await _firestore.collection('appointments').doc(id).update(data);
        Get.snackbar("Berhasil", "Janji temu berhasil diperbarui",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.blue, colorText: Colors.white);
      } catch (e) {
        Get.snackbar("Gagal", "Gagal memperbarui janji temu: $e",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      Get.snackbar("Offline", "Tidak bisa memperbarui data saat offline",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
    }
  }

  // Fungsi menghapus janji temu
  void deleteAppointment(String id) async {
    if (isConnected.value) {
      try {
        await _firestore.collection('appointments').doc(id).delete();
        Get.snackbar("Berhasil", "Janji temu berhasil dihapus",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      } catch (e) {
        Get.snackbar("Gagal", "Gagal menghapus janji temu: $e",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      Get.snackbar("Offline", "Tidak bisa menghapus data saat offline",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
    }
  }

  // Menyimpan data lokal jika koneksi terputus
  void _saveToLocal(Map<String, dynamic> data) {
    List<dynamic> pending = box.read('pending_appointments') ?? [];
    pending.add(data);
    box.write('pending_appointments', pending);
  }

  // Mengunggah ulang data lokal saat koneksi kembali aktif
  void retryPendingUploads() async {
    List<dynamic> pending = box.read('pending_appointments') ?? [];
    if (pending.isNotEmpty) {
      for (var data in pending) {
        try {
          await _firestore.collection('appointments').add(data);
        } catch (e) {
          print("Gagal mengunggah ulang data: $e");
        }
      }
      box.remove('pending_appointments');
      print("Semua data lokal berhasil diunggah ke Firebase.");
    }
  }
}
