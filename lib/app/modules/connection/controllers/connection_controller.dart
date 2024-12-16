import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionController extends GetxController {
  var isConnected = false.obs; // Status koneksi (true jika terhubung)

  @override
  void onInit() {
    super.onInit();
    _checkConnectivity();
    _listenConnectivity();
  }

  // Memeriksa status koneksi awal
  Future<void> _checkConnectivity() async {
    List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    _updateConnectionStatus(results);
  }

  // Memantau perubahan status koneksi
  void _listenConnectivity() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  // Memperbarui status koneksi berdasarkan hasil
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Mengecek jika ada koneksi WiFi atau Mobile
    bool hasConnection = results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile);

    isConnected.value = hasConnection;
  }
}
